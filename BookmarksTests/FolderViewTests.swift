import SwiftUI
import ViewInspector
import XCTest

@testable import Bookmarks

final class FolderViewTests: XCTestCase {
    func testFolderViewWhenLoadingShouldDisplayAllFolders() throws {
        let sut = FolderView()

        let folderLabel = try sut.inspect().findAll(FolderLabel.self)
        for (index, folder) in Folder.allCases.enumerated() {
            XCTAssertEqual(try folderLabel[index].actualView().folder, folder)
        }
    }
}
