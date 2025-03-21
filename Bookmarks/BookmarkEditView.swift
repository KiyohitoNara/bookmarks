import OSLog
import SwiftData
import SwiftUI

struct BookmarkEditView: View {
    let bookmark: Bookmark?
    
    @Environment(\.modelContext) private var context
    
    @State private var name: String
    @State private var url: String
    @State private var note: String
    @State private var folder: Folder
    
    internal var didAppear: ((Self) -> Void)?
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BookmarkEditView")
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $name)
                TextField("URL", text: $url)
            }

            Section(header: Text("Note")) {
                TextEditor(text: $note)
            }

            Section(header: Text("Location")) {
                Picker("Folder", selection: $folder) {
                    Text("Favorites").tag(Folder.favorites)
                    Text("Reading list").tag(Folder.readingList)
                    Text("Vault").tag(Folder.vault)
                }
                .pickerStyle(.menu)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Edit Bookmark")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    upsertBookmark()
                }
                .disabled(name.isEmpty || url.isEmpty)
            }
        }
        .onAppear {
            self.didAppear?(self)
        }
    }

    init(_ bookmark: Bookmark? = nil) {
        self.bookmark = bookmark
        self._name = State(initialValue: bookmark?.name ?? "")
        self._url = State(initialValue: bookmark?.url.absoluteString ?? "")
        self._note = State(initialValue: bookmark?.note ?? "")
        self._folder = State(initialValue: bookmark?.folder ?? .favorites)
    }

    private func upsertBookmark() {
        if let bookmark = bookmark {
            logger.debug("Updating bookmark: \(name)")
            
            bookmark.name = name
            bookmark.url = URL(string: url)!
            bookmark.note = note.isEmpty ? nil : note
            bookmark.folder = folder
        } else {
            logger.debug("Creating bookmark: \(name)")
            
            let newBookmark = Bookmark(url: URL(string: url)!, name: name, note: note, folder: folder)
            context.insert(newBookmark)
        }

        do {
            try context.save()
        } catch {
            logger.error("Failed to save context: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        BookmarkEditView(nil)
    }
    .modelContainer(for: Bookmark.self, inMemory: true)
}
