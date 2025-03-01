import SwiftUI
import ViewInspector
import XCTest

@testable import Bookmarks

final class FolderViewTests: XCTestCase {
    func testFolderView() throws {
        let sut = FolderView()
        let list = try sut.inspect().implicitAnyView().list()

        for (index, folder) in Folder.allCases.enumerated() {
            let label = try list.forEach(0)[index].view(FolderLabel.self).actualView()
            XCTAssertEqual(label.folder, folder)
        }
    }
}
