//
//  BookmarksApp.swift
//  Bookmarks
//
//  Created by Kiyohito Nara on 2025/02/01.
//

import SwiftUI
import SwiftData

@main
struct BookmarksApp: App {
    var sharedModelContainer: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: ProcessInfo.processInfo.arguments.contains("isStoredInMemoryOnly"))

        do {
            let container = try ModelContainer(for: Bookmark.self, configurations: configuration)
            if ProcessInfo.processInfo.arguments.contains("hasTestBookmarks") {
                container.mainContext.insert(Bookmark(url: URL(string: "https://www.apple.com")!, name: "Apple", folder: .favorites))
                container.mainContext.insert(Bookmark(url: URL(string: "https://www.google.com")!, name: "Google", folder: .favorites))
                container.mainContext.insert(Bookmark(url: URL(string: "https://www.amazon.com")!, name: "Amazon", folder: .favorites))
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
