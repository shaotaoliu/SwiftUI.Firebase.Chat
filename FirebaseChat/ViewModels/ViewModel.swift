import Foundation

class ViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var hasMessage = false
    @Published var messageType: MessageType?
    @Published var messageText: String?
    
    func setMessage(_ type: MessageType, _ text: String) {
        self.messageType = type
        self.messageText = text
        self.hasMessage = true
    }
    
    var messageTitle: String {
        messageType?.rawValue.capitalized ?? ""
    }
}

enum MessageType: String {
    case error
    case info
}
