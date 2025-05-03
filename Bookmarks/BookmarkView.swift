import BetterSafariView
import LocalAuthentication
import OSLog
import SwiftData
import SwiftUI
import SwiftUIX

struct BookmarkView: View {
    private let folder: Folder

    @Environment(\.modelContext) private var context
    @Query(sort: \Bookmark.timestamp) private var bookmarks: [Bookmark]

    @State private var isLocked: Bool = true
    @State private var selectedBookmark: Bookmark? = nil

    internal var didAppear: ((Self) -> Void)?

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BookmarkView")

    var body: some View {
        List(bookmarks.filter { $0.folder == folder }) { bookmark in
            Button(bookmark.name, systemImage: "globe") {
                selectedBookmark = bookmark
            }
            .labelStyle(.titleAndIcon)
            .accentColor(.black)
            .contextMenu {
                NavigationLink(destination: BookmarkEditView(bookmark)) {
                    Label("Edit", systemImage: "pencil")
                }
                Button("Delete", systemImage: "trash", role: .destructive) {
                    context.delete(bookmark)
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            ContentUnavailableView {
                Label("Locked", systemImage: "lock")
            }
            .hidden(!isLocked)
            ContentUnavailableView {
                Label("No bookmarks", systemImage: "bookmark.slash")
            }
            .hidden(bookmarks.filter({ $0.folder == folder }).count > 0 || isLocked)
        }
        .safariView(item: $selectedBookmark) { bookmark in
            SafariView(url: bookmark.url)
        }
        .navigationTitle(folder.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Unlock", systemImage: "lock.open") {
                    Task {
                        await performAuthentication()
                    }
                }
                .hidden(!isLocked)
            }
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: BookmarkEditView()) {
                    Label("Add bookmark", systemImage: "plus")
                }
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

    private func performAuthentication() async {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            logger.error("Authentication not available: \(error?.localizedDescription ?? "Unknown error")")

            return
        }

        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock the vault")
            if success {
                logger.info("Authentication successful")

                isLocked = false
            }
        } catch {
            logger.error("Authentication failed: \(error.localizedDescription)")
        }
    }
}

#Preview("Favorites") {
    NavigationStack {
        BookmarkView(folder: .favorites)
    }
    .modelContainer(for: Bookmark.self, inMemory: true)
}

#Preview("Reading list") {
    NavigationStack {
        BookmarkView(folder: .readingList)
    }
    .modelContainer(for: Bookmark.self, inMemory: true)
}

#Preview("Vault") {
    NavigationStack {
        BookmarkView(folder: .vault)
    }
    .modelContainer(for: Bookmark.self, inMemory: true)
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
