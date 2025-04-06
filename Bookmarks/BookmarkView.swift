import SwiftData
import SwiftUI

struct BookmarkView: View {
    let folder: Folder

    @Environment(\.modelContext) private var context
    @Query(sort: \Bookmark.timestamp) private var bookmarks: [Bookmark]
    private var filteredBookmarks: [Bookmark] {
        return bookmarks.filter { $0.folder == folder }
    }
    
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
            BookmarkLabel(filteredBookmark)
        }
        .listStyle(.insetGrouped)
        .overlay {
            if filteredBookmarks.isEmpty {
                ContentUnavailableView {
                    Label("No bookmarks", systemImage: "bookmark.slash")
                } description: {
                    Text("No bookmarks in this folder.")
                }
            }
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
