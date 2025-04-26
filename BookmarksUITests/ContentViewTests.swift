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
    
    func testNavigationToEditerWhenAddButtonTapped() throws {
        app.otherElements.buttons["navigation_link_0"].tap()
        app.otherElements.buttons["navigation_link_add_bookmark"].tap()
        
        XCTAssertTrue(app.navigationBars["Edit Bookmark"].exists)
    }
}
