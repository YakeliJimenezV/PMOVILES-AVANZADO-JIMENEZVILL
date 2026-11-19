import XCTest

@MainActor
final class StoryboardWorkflowUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchEnvironment["VENTAS_UI_TEST_STORE"] = UUID().uuidString
        app.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
    }

    private func button(_ id: String) -> XCUIElement { app.buttons[id] }

    private func tab(_ title: String) {
        app.tabBars.buttons[title].tap()
    }

    private func fill(_ id: String, _ value: String, secure: Bool = false) {
        let field = secure ? app.secureTextFields[id] : app.textFields[id]
        field.tap()
        if secure {
            for character in value { field.typeText(String(character)) }
        } else {
            field.typeText(value)
        }
    }

    private func row(_ table: String, containing name: String) -> XCUIElement {
        app.tables[table].cells.matching(NSPredicate(format: "label CONTAINS[c] %@", name)).firstMatch
    }

    private func register(_ role: String, name: String, username: String) {
        button("login.createAccount").tap()
        app.segmentedControls["register.role"].buttons[role].tap()
        fill("register.name", name)
        fill("register.username", username)
        fill("register.password", "abcdef", secure: true)
        fill("register.confirmation", "abcdef", secure: true)
        app.staticTexts["TU ROL"].tap()
        button("register.submit").tap()
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 8))
    }

    private func login(_ username: String) {
        fill("login.username", username)
        fill("login.password", "abcdef", secure: true)
        button("login.submit").tap()
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 8))
    }

    private func logout() {
        tab("Cuenta")
        button("account.logout").tap()
        app.alerts.buttons["Cerrar sesión"].tap()
        XCTAssertTrue(button("login.submit").waitForExistence(timeout: 5))
    }

    private func tabs(_ labels: [String]) {
        for label in labels {
            XCTAssertTrue(app.tabBars.buttons[label].exists, "Falta la pestaña " + label)
        }
        XCTAssertEqual(app.tabBars.buttons.count, labels.count)
    }

    private func addProduct(name: String, stock: String = "3") {
        tab("Productos")
        button("products.add").tap()
        fill("product.name", name)
        fill("product.category", "Oficina")
        fill("product.price", "10")
        fill("product.stock", stock)
        button("product.save").tap()
        XCTAssertTrue(row("products.list", containing: name).waitForExistence(timeout: 5))
    }

    private func addClient(name: String, document: String) {
        tab("Clientes")
        button("clients.add").tap()
        fill("client.name", name)
        fill("client.document", document)
        button("client.save").tap()
        XCTAssertTrue(row("clients.list", containing: name).waitForExistence(timeout: 5))
    }

    private func screenshot(_ title: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = title
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testCatalogueEditorsSearchFiltersAndDelete() {
        button("login.submit").tap()
        XCTAssertTrue(app.staticTexts["Completa todos los campos."].exists)
        register("Supervisor", name: "Rosa", username: "rosa")
        addProduct(name: "Lapiz")

        let product = row("products.list", containing: "Lapiz")
        product.tap()
        fill("product.name", " Azul")
        button("product.save").tap()
        let updated = row("products.list", containing: "Lapiz Azul")
        XCTAssertTrue(updated.waitForExistence(timeout: 5))
        button("products.filter.Oficina").tap()
        let search = app.searchFields["products.searchField"]
        search.tap()
        search.typeText("Azul\n")
        XCTAssertTrue(updated.exists)
        updated.swipeLeft()
        button("Borrar").tap()
        app.alerts.buttons["Eliminar"].tap()
        XCTAssertFalse(updated.exists)

        addClient(name: "Clara", document: "10")
        row("clients.list", containing: "Clara").tap()
        fill("client.name", " Diaz")
        button("client.save").tap()
        button("clients.add").tap()
        fill("client.name", "Otro")
        fill("client.document", "10")
        button("client.save").tap()
        XCTAssertTrue(app.staticTexts["client.error"].label.contains("documento"))
        button("Cancelar").tap()
        let clientSearch = app.searchFields["clients.search"]
        clientSearch.tap()
        clientSearch.typeText("10\n")
        let client = row("clients.list", containing: "Clara Diaz")
        XCTAssertTrue(client.exists)
        client.swipeLeft()
        button("Borrar").tap()
        app.alerts.buttons["Eliminar"].tap()
        XCTAssertFalse(client.exists)
    }

    func testSaleAcrossRolesPersistenceStockAndCancellation() {
        register("Supervisor", name: "Rosa", username: "rosa")
        tabs(["Resumen", "Ventas", "Productos", "Clientes", "Cuenta"])
        XCTAssertTrue(app.staticTexts["dashboard.today"].exists)
        addProduct(name: "Carpeta")
        addClient(name: "Alicia", document: "20")
        logout()

        register("Vendedor", name: "Luis", username: "luis")
        tabs(["Productos", "Clientes", "Ventas", "Mis ventas", "Cuenta"])
        XCTAssertFalse(button("products.add").exists)
        tab("Ventas")
        button("sale.client").tap()
        row("sale.choices", containing: "Alicia").tap()
        button("sale.product").tap()
        row("sale.choices", containing: "Carpeta").tap()
        button("sale.plus").tap()
        XCTAssertEqual(app.staticTexts["sale.quantity"].label, "2")
        XCTAssertTrue(app.staticTexts["sale.total"].label.contains("23.60"))
        screenshot("Nueva venta con IGV")
        let submit = button("sale.submit")
        if !submit.isHittable { app.scrollViews.firstMatch.swipeUp() }
        submit.tap()
        XCTAssertTrue(app.alerts["Venta registrada"].waitForExistence(timeout: 4))
        app.alerts.buttons["Aceptar"].tap()
        tab("Mis ventas")
        app.segmentedControls["mysales.period"].buttons["Hoy"].tap()
        XCTAssertTrue(row("mysales.list", containing: "Alicia").label.contains("Vigente"))
        XCTAssertTrue(app.staticTexts["mysales.todayTotal"].label.contains("23.60"))
        tab("Productos")
        XCTAssertTrue(row("products.list", containing: "Carpeta").label.contains("1 unidades"))
        tab("Cuenta")
        XCTAssertEqual(app.staticTexts["account.role"].label, "Vendedor")
        XCTAssertEqual(app.staticTexts["account.username"].label, "luis")
        button("account.logout").tap()
        app.alerts.buttons["Cancelar"].tap()
        XCTAssertEqual(app.staticTexts["account.name"].label, "Luis")

        app.terminate()
        app.launch()
        XCTAssertTrue(button("login.submit").exists)
        login("rosa")
        XCTAssertTrue(app.staticTexts["dashboard.today"].label.contains("23.60"))
        XCTAssertTrue(app.staticTexts["dashboard.tax"].label.contains("3.60"))
        screenshot("Resumen del Supervisor")
        tab("Ventas")
        app.segmentedControls["team.period"].buttons["Mes"].tap()
        button("Luis").tap()
        let search = app.searchFields["team.search"]
        search.tap()
        search.typeText("Ali\n")
        let sale = row("team.list", containing: "Alicia")
        XCTAssertTrue(sale.label.contains("Vigente"))
        sale.tap()
        button("cancel.confirm").tap()
        XCTAssertTrue(app.staticTexts["cancel.error"].label.contains("motivo"))
        fill("cancel.reason", "Devolucion\n")
        button("cancel.confirm").tap()
        XCTAssertTrue(sale.label.contains("Anulada"))
        sale.tap()
        XCTAssertTrue(app.alerts["Motivo de anulación"].staticTexts["Devolucion"].exists)
        app.alerts.buttons["Aceptar"].tap()
        tab("Productos")
        XCTAssertTrue(row("products.list", containing: "Carpeta").label.contains("3 unidades"))
        tab("Resumen")
        XCTAssertTrue(app.staticTexts["dashboard.today"].label.contains("0.00"))
        logout()
        login("luis")
        tab("Mis ventas")
        XCTAssertTrue(row("mysales.list", containing: "Alicia").label.contains("Anulada"))
        XCTAssertTrue(app.staticTexts["mysales.monthTotal"].label.contains("0.00"))
        logout()
    }
}
