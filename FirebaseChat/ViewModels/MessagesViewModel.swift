import SwiftUI

class MessagesViewModel: ViewModel {
    @Published var messages: [MessageModel] = []
    @Published var textToSend: String = ""
    @Published var imageToSend: UIImage?
    @Published var showImagePicker = false
    @Published var latestMessageId: String? = nil
    
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
    
    func getMessages(toId: String) {
        let fromId = AuthService.shared.currentUser!.uid
        
        MessageService.shared.getMessages(fromId: fromId, toId: toId) { messages, error in
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            if let result = messages {
                self.messages = result
                self.latestMessageId = result.last?.id
            }
        }
    }
    
    func markRecentMessageAsRead(toId: String) {
        let fromId = AuthService.shared.currentUser!.uid
        
        MessageService.shared.markRecentMessageAsRead(fromId: fromId, toId: toId) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
