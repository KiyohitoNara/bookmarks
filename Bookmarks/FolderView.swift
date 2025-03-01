import SwiftUI

struct FolderView: View {
    var body: some View {
        List(Folder.allCases, id: \.self) { folder in
            FolderLabel(folder)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Bookmarks")
    }
}

#Preview {
    NavigationStack {
        FolderView()
    }
}
