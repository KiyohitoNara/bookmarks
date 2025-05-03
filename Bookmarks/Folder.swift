enum Folder: Int16, Codable, CaseIterable {
    case favorites = 0
    case readingList = 1
    case vault = 2
    
    var name: String {
        switch self {
        case .favorites:
            return "Favorites"
        case .readingList:
            return "Reading list"
        case .vault:
            return "Vault"
        }
    }
}
