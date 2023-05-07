//
//  FolderLabel.swift
//
//
//  Copyright (c) 2023 Kiyohito Nara. All rights reserved.
//

import SwiftUI

public struct FolderLabel: View {
    let folder: Folder

    public var body: some View {
        switch folder {
        case .favorites:
            Label("Favorites", systemImage: "book")
        case .readingList:
            Label("Reading List", systemImage: "eyeglasses")
        }
    }

    public init(folder: Folder) {
        self.folder = folder
    }
}

#if DEBUG
struct FolderLabel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                FolderLabel(folder: .favorites)
                FolderLabel(folder: .readingList)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Folders")
        }
    }
}
#endif
