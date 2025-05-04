import SwiftData
import SwiftUI
import ViewInspector
import XCTest

@testable import Bookmarks

@MainActor
final class BookmarkEditViewTests: XCTestCase {
    func testBookmarkEditViewShowsEmptyNameWhenCreatingBookmark() throws {
        var sut = BookmarkEditView(nil)
        let exp = sut.on(\.didAppear) { view in
            let nameTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "Name" })
            XCTAssertEqual(try nameTextField.input(), "")
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewShowsBookmarkNameWhenEdittingBookmark() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example")
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let nameTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "Name" })
            XCTAssertEqual(try nameTextField.input(), "Example")
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewShowsEmptyURLWhenCreatingBookmark() throws {
        var sut = BookmarkEditView(nil)
        let exp = sut.on(\.didAppear) { view in
            let urlTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "URL" })
            XCTAssertEqual(try urlTextField.input(), "")
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewShowsBookmarkURLWhenEdittingBookmark() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example")
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let urlTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "URL" })
            XCTAssertEqual(try urlTextField.input(), "https://www.example.com")
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewShowsEmptyNoteWhenCreatingBookmark() throws {
        var sut = BookmarkEditView(nil)
        let exp = sut.on(\.didAppear) { view in
            let noteTextEditor = try view.find(ViewType.TextEditor.self)
            XCTAssertEqual(try noteTextEditor.input(), "")
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewShowsBookmarkNoteWhenEditingBookmark() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example", note: "Example note")
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let noteTextEditor = try view.find(ViewType.TextEditor.self)
            XCTAssertEqual(try noteTextEditor.input(), "Example note")
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewShowsFavoritesFolderWhenCreatingBookmark() throws {
        var sut = BookmarkEditView()
        let exp = sut.on(\.didAppear) { view in
            let folderPicker = try view.find(ViewType.Picker.self)
            XCTAssertEqual(try folderPicker.selectedValue(Folder.self), .favorites)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewShowsSelectedFolderWhenEditingBookmark() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example", folder: .readingList)
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let folderPicker = try view.find(ViewType.Picker.self)
            XCTAssertEqual(try folderPicker.selectedValue(Folder.self), .readingList)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewEnablesSaveButtonWhenNameAndURLAreNotEmpty() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example")
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let nameTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "Name" })
            try nameTextField.setInput("Updated Example")
            XCTAssertEqual(try nameTextField.input(), "Updated Example")

            let urlTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "URL" })
            try urlTextField.setInput("https://www.example.net")
            XCTAssertEqual(try urlTextField.input(), "https://www.example.net")

            let saveButton = try view.find(ViewType.Button.self)
            XCTAssertFalse(saveButton.isDisabled())
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewDisablesSaveButtonWhenNameIsEmpty() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example")
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let nameTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "Name" })
            try nameTextField.setInput("")
            XCTAssertEqual(try nameTextField.input(), "")

            let saveButton = try view.find(ViewType.Button.self, where: { try $0.labelView().text().string() == "Save" })
            XCTAssertTrue(saveButton.isDisabled())
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewDisablesSaveButtonWhenURLIsEmpty() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example")
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let urlTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "URL" })
            try urlTextField.setInput("")
            XCTAssertEqual(try urlTextField.input(), "")

            let saveButton = try view.find(ViewType.Button.self)
            XCTAssertTrue(saveButton.isDisabled())
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)

        ViewHosting.host(view: sut.environment(\.modelContext, container.mainContext))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewCreatesBookmarkWhenSaveButtonTapped() throws {
        var sut = BookmarkEditView()
        let exp = sut.on(\.didAppear) { view in
            let nameTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "Name" })
            try nameTextField.setInput("Example")

            let urlTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "URL" })
            try urlTextField.setInput("https://www.example.com")

            let noteTextEditor = try view.find(ViewType.TextEditor.self)
            try noteTextEditor.setInput("Example note")

            let folderPicker = try view.find(ViewType.Picker.self)
            try folderPicker.select(value: Folder.vault)

            let saveButton = try view.find(ViewType.Button.self)
            try saveButton.tap()

            let bookmark = try view.environment(\.modelContext).fetch(FetchDescriptor<Bookmark>()).first
            XCTAssertNotNil(bookmark)
            XCTAssertEqual(bookmark?.name, "Example")
            XCTAssertEqual(bookmark?.url.absoluteString, "https://www.example.com")
            XCTAssertEqual(bookmark?.note, "Example note")
            XCTAssertEqual(bookmark?.folder, .vault)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)
        let context = container.mainContext

        ViewHosting.host(view: sut.environment(\.modelContext, context))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }

    func testBookmarkEditViewUpdatesBookmarkWhenSaveButtonTapped() throws {
        let bookmark = Bookmark(url: URL(string: "https://www.example.com")!, name: "Example")
        var sut = BookmarkEditView(bookmark)
        let exp = sut.on(\.didAppear) { view in
            let nameTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "Name" })
            try nameTextField.setInput("Updated Example")

            let urlTextField = try view.find(ViewType.TextField.self, where: { try $0.labelView().text().string() == "URL" })
            try urlTextField.setInput("https://www.example.net")

            let noteTextEditor = try view.find(ViewType.TextEditor.self)
            try noteTextEditor.setInput("Updated note")

            let folderPicker = try view.find(ViewType.Picker.self)
            try folderPicker.select(value: Folder.vault)

            let saveButton = try view.find(ViewType.Button.self, where: { try $0.labelView().text().string() == "Save" })
            try saveButton.tap()

            let updatedBookmark = try view.environment(\.modelContext).fetch(FetchDescriptor<Bookmark>()).first
            XCTAssertNotNil(updatedBookmark)
            XCTAssertEqual(updatedBookmark?.name, "Updated Example")
            XCTAssertEqual(updatedBookmark?.url.absoluteString, "https://www.example.net")
            XCTAssertEqual(updatedBookmark?.note, "Updated note")
            XCTAssertEqual(updatedBookmark?.folder, .vault)
        }

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)
        let context = container.mainContext
        context.insert(bookmark)

        ViewHosting.host(view: sut.environment(\.modelContext, context))
        defer { ViewHosting.expel() }

        wait(for: [exp], timeout: 0.1)
    }
}
