import SwiftUI
import ViewInspector
import XCTest

@testable import Bookmarks

final class FolderViewTests: XCTestCase {
    func testFolderView() throws {
        let sut = FolderView()

        for (_, folder) in Folder.allCases.enumerated() {
            let label = try sut.inspect().find(viewWithAccessibilityIdentifier: "folder_label_\(folder.rawValue)").view(FolderLabel.self).actualView()
            
            XCTAssertEqual(label.folder, folder)
        }
    }
}
