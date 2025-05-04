import SwiftUI
import ViewInspector
import XCTest

@testable import Bookmarks

final class ContentViewTests: XCTestCase {
    func testContentViewShowsFolderView() throws {
        let sut = ContentView()

        let folderView = try sut.inspect().find(FolderView.self)
        XCTAssertNotNil(folderView)
    }
}
