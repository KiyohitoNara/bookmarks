import Foundation
import SwiftData

@Model
final class Bookmark {
    var url: URL = URL(string: "https://www.apple.com")!
    var name: String = "Apple"
    var note: String = "Apple Inc."
    var folder: Folder = Folder.favorites
    var timestamp: Date = Date()

    init(url: URL, name: String, note: String = "", folder: Folder = .favorites, timestamp: Date = Date()) {
        self.url = url
        self.name = name
        self.note = note
        self.folder = folder
        self.timestamp = timestamp
    }
}
