import SwiftData
import SwiftUI
import ViewInspector
import XCTest

@testable import Bookmarks

@MainActor
final class BookmarkViewTests: XCTestCase {
    func testBookmarkViewShowsListForExistingBookmarks() throws {
        var sut = BookmarkView(folder: .favorites)
        let exp = sut.on(\.didAppear) { view in
            let emptyView = try view.find(text: "No bookmarks", locale: Locale(identifier: "en"))
            XCTAssertTrue(emptyView.isHidden())

            let list = try view.find(ViewType.List.self)
            let button = list.findAll(ViewType.Button.self)
            XCTAssertEqual(button.count, 3)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)
        container.mainContext.insert(Bookmark(url: URL(string: "https://www.apple.com")!, name: "Apple", folder: .favorites))
        container.mainContext.insert(Bookmark(url: URL(string: "https://www.google.com")!, name: "Google", folder: .favorites))
        container.mainContext.insert(Bookmark(url: URL(string: "https://www.amazon.com")!, name: "Amazon", folder: .favorites))

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkViewShowsEmptyViewForNoBookmarks() throws {
        var sut = BookmarkView(folder: .favorites)
        let exp = sut.on(\.didAppear) { view in
            let emptyView = try view.find(text: "No bookmarks", locale: Locale(identifier: "en"))
            XCTAssertFalse(emptyView.isHidden())
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkViewShowsLockedViewForVault() throws {
        var sut = BookmarkView(folder: .vault)
        let exp = sut.on(\.didAppear) { view in
            let emptyView = try view.find(text: "No bookmarks", locale: Locale(identifier: "en"))
            XCTAssertTrue(emptyView.isHidden())

            let lockedView = try view.find(text: "Locked", locale: Locale(identifier: "en"))
            XCTAssertFalse(lockedView.isHidden())
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkViewShowsUnlockButtonForVault() throws {
        var sut = BookmarkView(folder: .vault)
        let exp = sut.on(\.didAppear) { view in
            let button = try view.find(ViewType.Label.self, where: { try $0.title().text().string() == "Unlock" })
            XCTAssertFalse(button.isHidden())
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkViewDisplaysAddButton() throws {
        var sut = BookmarkView(folder: .favorites)
        let exp = sut.on(\.didAppear) { view in
            let button = try view.find(ViewType.Label.self, where: { try $0.title().text().string() == "Add bookmark" })
            XCTAssertNotNil(button)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }
}
