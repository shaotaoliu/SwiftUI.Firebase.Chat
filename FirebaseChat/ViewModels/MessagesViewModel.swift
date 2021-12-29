import SwiftUI

class MessagesViewModel: ViewModel {
    @Published var messages: [ChatMessage] = []
    @Published var textToSend: String = ""
    @Published var imageToSend: UIImage?
    @Published var showImagePicker = false
    
    func sendMessage(toId: String) {
        if textToSend.isEmpty && imageToSend == nil {
            return
        }
        
        let fromId = AuthService.shared.currentUser!.uid
        let message = ChatNewMessage(fromId: fromId, toId: toId, text: textToSend, Image: imageToSend)
        
        MessageService.shared.saveMessage(message: message) { error in
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            self.textToSend = ""
            self.imageToSend = nil
        }
    }
}

/*
 
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
 */
