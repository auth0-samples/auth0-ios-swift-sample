import XCTest

class SmokeTests: XCTestCase {

    private let email = ProcessInfo.processInfo.environment["USER_EMAIL"]!
    private let password = ProcessInfo.processInfo.environment["USER_PASSWORD"]!
    private let loginButton = "Login"
    private let logoutButton = "Logout"
    private let continueButton = "Continue"
    private let timeout: TimeInterval = 10

    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = ProcessInfo.processInfo.environment
        app.launch()
        app.buttons[loginButton].tap()
        tapAlert(button: continueButton)
    }

    func testLogin() {
        let app = XCUIApplication()
        login()
        XCTAssertTrue(app.buttons[logoutButton].waitForExistence(timeout: timeout))
        XCTAssertTrue(app.staticTexts[email].waitForExistence(timeout: timeout))
    }

    func testLogout() {
        let app = XCUIApplication()
        let sessionButton = app.webViews.staticTexts[email]
        XCTAssertTrue(sessionButton.waitForExistence(timeout: timeout))
        sessionButton.tap()
        XCTAssertTrue(app.buttons[logoutButton].waitForExistence(timeout: timeout))
        app.buttons[logoutButton].tap()
        tapAlert(button: continueButton)
        XCTAssertTrue(app.buttons[loginButton].waitForExistence(timeout: timeout))
    }

}

private extension SmokeTests {

    func tapAlert(button label: String) {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let button = springboard.buttons[label]
        XCTAssertTrue(button.waitForExistence(timeout: timeout))
        button.tap()
    }

    func login() {
        let app = XCUIApplication()
        let emailInput = app.webViews.textFields.firstMatch
        XCTAssertTrue(emailInput.waitForExistence(timeout: timeout))
        emailInput.tap()
        emailInput.typeText("\(email)\n")
        let passwordInput = app.webViews.secureTextFields.firstMatch
        passwordInput.tap()
        passwordInput.typeText(password)
        app.webViews.buttons.firstMatch.tap()
    }

}
