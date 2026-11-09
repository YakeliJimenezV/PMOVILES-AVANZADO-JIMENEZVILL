import UIKit

final class SupervisorDashboardViewController: SupervisorViewController {
    private let refresh = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        content.removeFromSuperview()
        let scroll = UIScrollView(); scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(content)
        scroll.refreshControl = refresh; refresh.addTarget(self, action: #selector(reload), for: .valueChanged)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 10), content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            content.centerXAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerXAnchor), content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        reload()
    }
    @objc private func reload() {
        defer { refresh.endRefreshing() }
        content.arrangedSubviews.forEach { content.removeArrangedSubview($0); $0.removeFromSuperview() }
        do {
            let now = Date(), summary = try supervisorService.dashboard()
            let formatter = DateFormatter(); formatter.locale = Locale(identifier: "es_PE"); formatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
            let date = CommerceUI.label(formatter.string(from: now), size: 12, color: .secondaryLabel)
            content.addArrangedSubview(date)
            let name = supervisorService.session?.name.split(separator: " ").first.map(String.init) ?? ""
            let hello = CommerceUI.label("Hola, \(name)", size: 24, bold: true)
            let role = CommerceUI.label("  \(supervisorService.session?.role.rawValue ?? "Supervisor")  ", size: 11, bold: true, color: .white)
            role.backgroundColor = .systemPurple; role.layer.cornerRadius = 8; role.clipsToBounds = true
            role.setContentHuggingPriority(.required, for: .horizontal); role.setContentCompressionResistancePriority(.required, for: .horizontal)
            content.addArrangedSubview(CommerceUI.row(hello, role))
            let today = CommerceUI.label(Money.text(summary.soldToday), size: 23, bold: true)
            let tax = CommerceUI.label(Money.text(summary.monthlyTax), size: 23, bold: true)
            today.accessibilityIdentifier = "dashboard.today"; tax.accessibilityIdentifier = "dashboard.tax"
            let metrics = UIStackView(arrangedSubviews: [
                CommerceUI.card([CommerceUI.label("Vendido hoy", size: 12, color: .secondaryLabel), today], spacing: 6),
                CommerceUI.card([CommerceUI.label("IGV del mes", size: 12, color: .secondaryLabel), tax], spacing: 6)
            ])
            metrics.axis = .horizontal; metrics.spacing = 10; metrics.distribution = .fillEqually
            content.addArrangedSubview(metrics)
            let chart = SevenDayChartView(days: summary.days)
            chart.heightAnchor.constraint(equalToConstant: 150).isActive = true
            content.addArrangedSubview(CommerceUI.card([CommerceUI.label("Ventas de los últimos 7 días (S/)", size: 12, color: .secondaryLabel), chart]))
            var rankingViews: [UIView] = [CommerceUI.label("Ranking de vendedores (mes)", size: 12, color: .secondaryLabel)]
            let maxTotal = max(summary.ranking.first?.total ?? 0, 1)
            for entry in summary.ranking {
                let text = CommerceUI.label("\(entry.name) · \(Money.text(entry.total))", size: 12, bold: true)
                let progress = UIProgressView(progressViewStyle: .default)
                progress.progressTintColor = AuthFormViewController.blue
                progress.trackTintColor = .systemGray5
                progress.progress = min(1, max(0, Float(Money.double(entry.total / maxTotal))))
                rankingViews.append(text); rankingViews.append(progress)
            }
            if summary.ranking.isEmpty { rankingViews.append(CommerceUI.label("Sin ventas válidas este mes.", size: 13, color: .secondaryLabel)) }
            let ranking = CommerceUI.card(rankingViews, spacing: 8); ranking.accessibilityIdentifier = "dashboard.ranking"
            content.addArrangedSubview(ranking)
            var stockViews: [UIView] = [CommerceUI.label("Stock bajo (≤ 5)", size: 12, color: .secondaryLabel)]
            for product in summary.lowStock {
                let productLabel = CommerceUI.label("\(product.name) · \(product.stock) u.", size: 14, bold: true)
                let badge = CommerceUI.label("  Reponer  ", size: 10, bold: true, color: .white)
                badge.backgroundColor = .systemRed; badge.layer.cornerRadius = 8; badge.clipsToBounds = true
                badge.setContentHuggingPriority(.required, for: .horizontal)
                badge.setContentCompressionResistancePriority(.required, for: .horizontal)
                stockViews.append(CommerceUI.row(productLabel, badge))
            }
            if summary.lowStock.isEmpty { stockViews.append(CommerceUI.label("No hay productos con stock bajo.", size: 13, color: .secondaryLabel)) }
            content.addArrangedSubview(CommerceUI.card(stockViews))
        } catch { content.addArrangedSubview(CommerceUI.label(error.localizedDescription, color: .systemRed)) }
    }
}

/// Native UIKit chart; no external dependencies and seven accessible daily values.
private final class SevenDayChartView: UIView {
    private let days: [DailySales]
    init(days: [DailySales]) { self.days = days; super.init(frame: .zero); backgroundColor = .clear }
    required init?(coder: NSCoder) { fatalError("Use init(days:)") }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !days.isEmpty else { return }
        let maxTotal = max(days.map { Money.double($0.total) }.max() ?? 0, 1)
        let weekdays = ["D", "L", "M", "X", "J", "V", "S"]
        let width = bounds.width / CGFloat(days.count), chartHeight = bounds.height - 26
        for (index, point) in days.enumerated() {
            let height = max(0, CGFloat(Money.double(point.total) / maxTotal) * chartHeight)
            let bar = CGRect(x: CGFloat(index) * width + 4, y: chartHeight - height, width: max(1, width - 9), height: height)
            (index == days.count - 1 ? AuthFormViewController.blue : UIColor(red: 0.86, green: 0.91, blue: 1, alpha: 1)).setFill()
            UIBezierPath(roundedRect: bar, cornerRadius: 4).fill()
            let paragraph = NSMutableParagraphStyle(); paragraph.alignment = .center
            (weekdays[Calendar.current.component(.weekday, from: point.date) - 1] as NSString).draw(in: CGRect(x: CGFloat(index) * width, y: chartHeight + 8, width: width, height: 18), withAttributes: [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.secondaryLabel, .paragraphStyle: paragraph])
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let formatter = DateFormatter(); formatter.dateStyle = .full; formatter.locale = Locale(identifier: "es_PE")
        accessibilityElements = days.enumerated().map { index, point in
            let element = UIAccessibilityElement(accessibilityContainer: self)
            element.accessibilityLabel = "\(formatter.string(from: point.date)): \(Money.text(point.total))"
            element.accessibilityTraits = .staticText
            element.accessibilityFrameInContainerSpace = CGRect(x: CGFloat(index) * bounds.width / 7, y: 0, width: bounds.width / 7, height: bounds.height)
            return element
        }
        setNeedsDisplay()
    }
}
