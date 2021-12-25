import SwiftUI
import FirebaseAuth
import FirebaseStorage

class MainViewModel: ObservableObject {
    @Published var email = ""
    @Published var photo: UIImage?
    
    init() {
        loadUserData()
    }
    
    func loadUserData() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        self.email = user.email!
        let ref = Storage.storage().reference(withPath: user.uid)
        
        ref.getData(maxSize: 1024 * 1024) { data, error in
            if let error = error {
                print("Cannot download user image: \(error)")
                return
            }
            
            self.photo = UIImage(data: data!)
        }
    }
}
