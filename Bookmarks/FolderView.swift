import SwiftUI

struct FolderView: View {
    var body: some View {
        List(Folder.allCases, id: \.self) { folder in
            NavigationLink(destination: BookmarkView(folder: folder)) {
                FolderLabel(folder)
                    .accessibilityIdentifier("folder_label_\(folder.rawValue)")
            }
            .accessibilityIdentifier("navigation_link_\(folder.rawValue)")
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Bookmarks")
        .accessibilityIdentifier("list_folder")
    }
}

#Preview {
    NavigationStack {
        FolderView()
    }
}
