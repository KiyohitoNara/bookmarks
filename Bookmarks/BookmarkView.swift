import BetterSafariView
import SwiftData
import SwiftUI
import LocalAuthentication

struct BookmarkView: View {
    let folder: Folder

    @Environment(\.modelContext) private var context
    @Query(sort: \Bookmark.timestamp) private var bookmarks: [Bookmark]
    private var filteredBookmarks: [Bookmark] {
        return bookmarks.filter { $0.folder == folder }
    }

    @State private var isLocked: Bool = false
    @State private var selectedBookmark: Bookmark? = nil

    private var navigationTitle: String {
        switch folder {
        case .favorites:
            return "Favorites"
        case .readingList:
            return "Reading list"
        default:
            return "Vault"
        }
    }

    internal var didAppear: ((Self) -> Void)?

    var body: some View {
        List(filteredBookmarks) { filteredBookmark in
            Button(filteredBookmark.name, systemImage: "globe") {
                selectedBookmark = filteredBookmark
            }
            .labelStyle(.titleAndIcon)
            .accentColor(.black)
            .contextMenu {
                NavigationLink(destination: BookmarkEditView(filteredBookmark)) {
                    Label("Edit", systemImage: "pencil")
                }
                Button("Delete", systemImage: "trash", role: .destructive) {
                    context.delete(filteredBookmark)
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if isLocked {
                ContentUnavailableView {
                    Label("Locked", systemImage: "lock")
                } description: {
                    Text("Unlock to view bookmarks.")
                } actions: {
                    Button("Unlock") {
                        authenticate()
                    }
                    .accessibilityIdentifier("button_unlock")
                }
            } else if filteredBookmarks.isEmpty {
                ContentUnavailableView {
                    Label("No bookmarks", systemImage: "bookmark.slash")
                } description: {
                    Text("No bookmarks in this folder.")
                }
            }
        }
        .safariView(item: $selectedBookmark) { bookmark in
            SafariView(url: bookmark.url)
        }
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: BookmarkEditView()) {
                    Label("Add bookmark", systemImage: "plus")
                        .accessibilityIdentifier("button_add_bookmark")
                }
                .accessibilityIdentifier("navigation_link_add_bookmark")
            }
        }
        .onAppear {
            self.didAppear?(self)
        }
    }

    init(folder: Folder) {
        self.folder = folder
        self._isLocked = State(initialValue: folder == .vault)
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock the vault") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isLocked = false
                    }
                }
            }
        }
    }
}

#if DEBUG
    struct BookmarkView_Previews: PreviewProvider {
        static var container: some ModelContainer {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: Bookmark.self, configurations: configuration)
            container.mainContext.insert(Bookmark(url: URL(string: "https://www.apple.com")!, name: "Apple", folder: .favorites))
            container.mainContext.insert(Bookmark(url: URL(string: "https://www.google.com")!, name: "Google", folder: .favorites))
            container.mainContext.insert(Bookmark(url: URL(string: "https://www.amazon.com")!, name: "Amazon", folder: .favorites))

            return container
        }

        static var previews: some View {
            NavigationStack {
                BookmarkView(folder: .favorites)
            }
            .modelContainer(container)
        }
    }
#endif

#Preview {
    NavigationStack {
        BookmarkView(folder: .favorites)
    }
    .modelContainer(for: Bookmark.self, inMemory: true)
}
