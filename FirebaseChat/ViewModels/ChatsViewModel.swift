import Foundation

class ChatsViewModel: ViewModel {
    @Published var recentMessages: [RecentMessage] = []
    @Published var searchText: String = ""
    
    override init() {
        super.init()
        getRecentMessages()
    }
    
    var filteredMessage: [RecentMessage] {
        var list: [RecentMessage] = []
        
        if searchText.isEmpty {
            list = recentMessages
        } else {
            list = recentMessages.filter {
                $0.recipient.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return list.sorted { $0.sentTime > $1.sentTime }
    }
    
    func getRecentMessages() {
        let userId = AuthService.shared.currentUser!.uid
        
        MessageService.shared.getRecentMessages(userId: userId) { recentMessages, error in
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            if let recentMessages = recentMessages {
                self.recentMessages.removeAll()
                
                for message in recentMessages {
                    UserService.shared.get(id: message.id!) { user, error in
                        if let user = user {
                            self.recentMessages.append(RecentMessage(
                                id: message.id!,
                                text: message.text,
                                sentTime: message.sentTime,
                                alreadyRead: message.alreadyRead,
                                recipient: MessageRecipient(displayName: user.displayName, photoURL: user.photoURL)))
                        }
                    }
                }
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
