import XCTest

final class ContentViewTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil

        try super.tearDownWithError()
    }

    func testNavigationToFavoritesWhenFirstFolderTapped() throws {
        app.otherElements.buttons["navigation_link_0"].tap()

        XCTAssertTrue(app.navigationBars["Favorites"].exists)
    }

    func testNavigationToReadingListWhenSecondFolderTapped() throws {
        app.otherElements.buttons["navigation_link_1"].tap()

        XCTAssertTrue(app.navigationBars["Reading list"].exists)
    }

    func testNavigationToVaultWhenThirdFolderTapped() throws {
        app.otherElements.buttons["navigation_link_2"].tap()

        XCTAssertTrue(app.navigationBars["Vault"].exists)
    }
}
