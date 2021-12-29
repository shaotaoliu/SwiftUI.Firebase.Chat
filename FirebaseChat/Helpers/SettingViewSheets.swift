import Foundation

enum SettingViewSheets: Identifiable {
    case displayName
    case email
    case password
    case delete
    
    var id: UUID {
        return UUID()
    }
}
