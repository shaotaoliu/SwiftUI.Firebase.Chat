import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift

struct MessageModel: Codable {
    @DocumentID var id: String?
    var text: String
    var isImage: Bool
    var fromMe: Bool
    var sentTime: Date
}

struct ChatMessage {
    var id: String
    var text: String
    var isImage: Bool
    var fromMe: Bool
    var sentTime: Date
}

struct ChatNewMessage {
    var fromId: String
    var toId: String
    var text: String?
    var Image: UIImage?
}

struct RecentMessageModel: Codable {
    @DocumentID var id: String?
    var text: String
    var sentTime: Date
    var alreadyRead: Bool
}

struct RecentMessage {
    let text: String
    var sentTime: Date
    let alreadyRead: Bool
    let recipient: MessageRecipient
}

struct MessageRecipient {
    let displayName: String
    let photoURL: String?
}
