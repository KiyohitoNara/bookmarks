import XCTest

final class BookmarkViewTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launchArguments.append("isStoredInMemoryOnly")
        app.launchArguments.append("hasTestBookmarks")
        app.launch()
        
        // Navigate FoldderView to BookmarkView
        app.otherElements.buttons["navigation_link_0"].tap()
    }

    override func tearDownWithError() throws {
        app = nil

        try super.tearDownWithError()
    }
    
    func testNavigationToSafariWhenBookmarkTapped() throws {
        let label = app.staticTexts["Apple"]
        label.tap()
        
        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 5))
    }
    
    func testNavigationToEditorWhenEditButtonTapped() throws {
        let label = app.staticTexts["Apple"]
        label.press(forDuration: 1.0)
        
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.exists)
        
        editButton.tap()
        XCTAssertTrue(app.navigationBars["Edit Bookmark"].exists)
    }
    
    func testDeleteBookmarkWhenDeleteButtonTapped() throws {
        let label = app.staticTexts["Apple"]
        label.press(forDuration: 1.0)
        
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.exists)
        
        deleteButton.tap()
        XCTAssertFalse(label.exists)
    }
}
