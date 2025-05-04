import XCTest

final class BookmarkEditViewTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments.append("isStoredInMemoryOnly")
        app.launchArguments.append("hasTestBookmarks")
        app.launch()

        // Navigate FoldderView to BookmarkView
        app.otherElements.buttons["Favorites"].tap()

        // Navigate BookmarkView to BookmarkEditView
        app.buttons["Apple"].press(forDuration: 1.0)
        app.buttons["Edit"].tap()
    }

    override func tearDownWithError() throws {
        app = nil

        try super.tearDownWithError()
    }

    func testBookmarkEditViewDismissesWhenSaveButtonTapped() throws {
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists)

        saveButton.tap()
        XCTAssertTrue(app.navigationBars["Favorites"].exists)
    }
}
