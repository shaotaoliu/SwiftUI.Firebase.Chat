import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift

struct UserModel: Codable {
    @DocumentID var id: String?
    var displayName: String
    var photoURL: String?
    var email: String
    
    init(id: String, displayName: String, photoURL: String?, email: String) {
        self.id = id
        self.displayName = displayName
        self.photoURL = photoURL
        self.email = email
    }
    
    init(from user: User) {
        self.init(id: user.uid, displayName: user.displayName!, photoURL: user.photoURL?.absoluteString, email: user.email!)
    }
}
