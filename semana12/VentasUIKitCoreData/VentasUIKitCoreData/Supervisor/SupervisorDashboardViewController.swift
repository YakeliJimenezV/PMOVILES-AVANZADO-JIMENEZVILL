import UIKit

final class SupervisorDashboardViewController: SupervisorViewController {
    @IBOutlet private weak var scroll: UIScrollView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var greeting: UILabel!
    @IBOutlet private weak var roleLabel: UILabel!
    @IBOutlet private weak var todayAmount: UILabel!
    @IBOutlet private weak var taxAmount: UILabel!
    @IBOutlet private weak var chart: SevenDayChartView!
    @IBOutlet private weak var ranking: UIStackView!
    @IBOutlet private weak var stock: UIStackView!
    @IBOutlet private weak var emptyRanking: UILabel!
    @IBOutlet private weak var emptyStock: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.refreshControl = UIRefreshControl()
        scroll.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        reload()
    }

    @objc private func reload() {
        defer { scroll.refreshControl?.endRefreshing() }
        for row in ranking.arrangedSubviews where row !== emptyRanking { row.removeFromSuperview() }
        for row in stock.arrangedSubviews where row !== emptyStock { row.removeFromSuperview() }
        errorLabel.isHidden = true
        do {
            let now = Date()
            let summary = try supervisorService.dashboard(now: now)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es_PE")
            formatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
            dateLabel.text = formatter.string(from: now)
            let name = supervisorService.session?.name.split(separator: " ").first.map(String.init) ?? ""
            greeting.text = "Hola, \(name)"
            roleLabel.text = "  \(supervisorService.session?.role.rawValue ?? "")  "
            todayAmount.text = Money.text(summary.soldToday)
            taxAmount.text = Money.text(summary.monthlyTax)
            chart.days = summary.days
            emptyRanking.isHidden = !summary.ranking.isEmpty
            emptyStock.isHidden = !summary.lowStock.isEmpty

            let maxTotal = max(summary.ranking.first?.total ?? 0, 1)
            for entry in summary.ranking {
                let text = CommerceUI.label("\(entry.name) · \(Money.text(entry.total))", size: 12, bold: true)
                let progress = UIProgressView(progressViewStyle: .default)
                progress.progressTintColor = AuthFormViewController.blue
                progress.trackTintColor = .systemGray5
                progress.progress = min(1, max(0, Float(Money.double(entry.total / maxTotal))))
                ranking.addArrangedSubview(text)
                ranking.addArrangedSubview(progress)
            }
            for product in summary.lowStock {
                let productLabel = CommerceUI.label("\(product.name) · \(product.stock) u.", size: 14, bold: true)
                let badge = CommerceUI.label("  Reponer  ", size: 10, bold: true, color: .white)
                badge.backgroundColor = .systemRed; badge.layer.cornerRadius = 8; badge.clipsToBounds = true
                badge.setContentHuggingPriority(.required, for: .horizontal)
                badge.setContentCompressionResistancePriority(.required, for: .horizontal)
                stock.addArrangedSubview(CommerceUI.row(productLabel, badge))
            }
        } catch {
            todayAmount.text = "S/ —"
            taxAmount.text = "S/ —"
            chart.days = []
            emptyRanking.isHidden = true
            emptyStock.isHidden = true
            errorLabel.text = error.localizedDescription
            errorLabel.isHidden = false
        }
    }
}

/// Native UIKit chart; no external dependencies and seven accessible daily values.
final class SevenDayChartView: UIView {
    var days: [DailySales] = [] {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }

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
