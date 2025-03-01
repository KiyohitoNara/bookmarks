import SwiftUI

struct FolderLabel: View {
    let folder: Folder

    var body: some View {
        switch folder {
        case Folder.favorites:
            Label("Favorites", systemImage: "book")
        case Folder.readingList:
            Label("Reading list", systemImage: "eyeglasses")
        case Folder.vault:
            Label("Vault", systemImage: "lock")
        }
    }

    init(_ folder: Folder) {
        self.folder = folder
    }
}

#Preview {
    FolderLabel(.favorites)
    FolderLabel(.readingList)
    FolderLabel(.vault)
}
