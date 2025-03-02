import SwiftUI

struct BookmarkLabel: View {
    let bookmark: Bookmark

    var body: some View {
        Label(bookmark.name, systemImage: "globe")
    }

    init(_ bookmark: Bookmark) {
        self.bookmark = bookmark
    }
}

#Preview {
    BookmarkLabel(
        Bookmark(url: URL(string: "https://www.apple.com")!, name: "Apple", folder: .favorites))
}
