import SwiftData
import SwiftUI
import ViewInspector
import XCTest

@testable import Bookmarks

@MainActor
final class BookmarkViewTests: XCTestCase {
    func testBookmarkView() throws {
        var sut = BookmarkView(folder: .favorites)
        let exp = sut.on(\.didAppear) { view in
            let list = try view.implicitAnyView().list()
            XCTAssertEqual(try list.forEach(0).count, 3)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)
        container.mainContext.insert(Bookmark(url: URL(string: "https://www.apple.com")!, name: "Apple", folder: .favorites))
        container.mainContext.insert(Bookmark(url: URL(string: "https://www.google.com")!, name: "Google", folder: .favorites))
        container.mainContext.insert(Bookmark(url: URL(string: "https://www.amazon.com")!, name: "Amazon", folder: .favorites))

        ViewHosting.host(
            view: sut.environment(\.modelContext, container.mainContext)
        )
        defer { ViewHosting.expel() }
        wait(for: [exp], timeout: 0.1)
    }
    
    func testBookmarkViewDisplayUnlockButton() throws {
        var sut = BookmarkView(folder: .vault)
        let exp = sut.on(\.didAppear) { view in
            let button = try view.find(viewWithAccessibilityIdentifier: "button_unlock").button()
            
            XCTAssertNotNil(button)
        }
        
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)
        
        ViewHosting.host(
            view: sut.environment(\.modelContext, container.mainContext)
        )
        defer { ViewHosting.expel() }
        wait(for: [exp], timeout: 0.1)
    }
    
    func testBookmarkViewDisplayAddButton() throws {
        var sut = BookmarkView(folder: .favorites)
        let exp = sut.on(\.didAppear) { view in
            let label = try view.find(viewWithAccessibilityIdentifier: "button_add_bookmark").label()
            
            XCTAssertNotNil(label)
        }
        
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)
        
        ViewHosting.host(
            view: sut.environment(\.modelContext, container.mainContext)
        )
        defer { ViewHosting.expel() }
        wait(for: [exp], timeout: 0.1)
    }
}
