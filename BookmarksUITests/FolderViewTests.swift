import XCTest

final class FolderViewTests: XCTestCase {
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

    func testFolderViewShowsBookmarkViewWhenFavoritesTapped() throws {
        app.buttons["Favorites"].tap()

        XCTAssertTrue(app.navigationBars["Favorites"].exists)
    }

    func testFolderViewShowsBookmarkViewWhenReadingListTapped() throws {
        app.buttons["Reading list"].tap()

        XCTAssertTrue(app.navigationBars["Reading list"].exists)
    }

    func testFolderViewShowsBookmarkViewWhenVaultTapped() throws {
        app.buttons["Vault"].tap()

        XCTAssertTrue(app.navigationBars["Vault"].exists)
    }
}
