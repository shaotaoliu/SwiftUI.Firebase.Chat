import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class MessageService {
    static let shared = MessageService()
    
    private init() {}
    
    private let messagesCollection = Firestore.firestore().collection("messages")
    private let recentMessagesCollection = Firestore.firestore().collection("recentMessages")
    
    func saveMessage(message: ChatNewMessage, completion: @escaping (Error?) -> Void) {
        if let image = message.Image {
            // we only need the url, so we can use a UUID here
            StorageService.shared.storeImage(source: .message, id: UUID().uuidString, image: image) { url, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.saveMessage(fromId: message.fromId, toId: message.toId,
                                 text: url!.absoluteString, isImage: true, completion: completion)
            }
        }
        else {
            saveMessage(fromId: message.fromId, toId: message.toId,
                        text: message.text ?? "", isImage: false, completion: completion)
        }
    }
    
    private func saveMessage(fromId: String, toId: String, text: String, isImage: Bool, completion: @escaping (Error?) -> Void) {
        let senderDocument = messagesCollection.document(fromId).collection(toId).document()
        let recipientDocument = messagesCollection.document(toId).collection(fromId).document()
        let now = Date()
  
        let sentMessage = MessageModel(text: text, isImage: isImage, fromMe: true, sentTime: now)
        
        try? senderDocument.setData(from: sentMessage) { error in
            if let error = error {
                completion(error)
                return
            }
            
            let receivedMessage = MessageModel(text: text, isImage: isImage, fromMe: false, sentTime: now)
            
            try? recipientDocument.setData(from: receivedMessage) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.saveRecentMessage(fromId: fromId, toId: toId, text: isImage ? "[Photo]" : text, sentTime: now, completion: completion)
            }
        }
    }
    
    private func saveRecentMessage(fromId: String, toId: String, text: String, sentTime: Date, completion: @escaping (Error?) -> Void) {
        let senderDocument = recentMessagesCollection.document(fromId).collection("messages").document()
        let recipientDocument = recentMessagesCollection.document(toId).collection("messages").document()
        
        let sentMessage = RecentMessageModel(id: toId, text: text, sentTime: sentTime, alreadyRead: true)
        
        try? senderDocument.setData(from: sentMessage) { error in
            if let error = error {
                completion(error)
                return
            }
            
            let receivedMessage = RecentMessageModel(id: fromId, text: text, sentTime: sentTime, alreadyRead: false)
            
            try? recipientDocument.setData(from: receivedMessage) { error in
                completion(error)
            }
        }
    }
    
    func getRecentMessages(userId: String, completion: @escaping ([MessageModel]?, Error?) -> Void) {
        recentMessagesCollection
            .document(userId)
            .collection("messages")
            .order(by: "sentTime")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let messages = snapshot?.documents.compactMap {
                    try? $0.data(as: MessageModel.self)
                }
                
                completion(messages, nil)
            }
    }
    
    func getMessages(fromId: String, toId: String, completion: @escaping ([MessageModel]?, Error?) -> Void) {
        messagesCollection
            .document(fromId)
            .collection(toId)
            .order(by: "sendTime")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let messages = snapshot?.documents.compactMap {
                    try? $0.data(as: MessageModel.self)
                }
                
                completion(messages, nil)
            }
    }
}
