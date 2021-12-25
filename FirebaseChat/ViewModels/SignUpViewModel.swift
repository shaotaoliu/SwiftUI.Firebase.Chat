import SwiftUI
import FirebaseAuth
import FirebaseStorage

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var photo: UIImage?
    @Published var showImagePicker = false
    @Published var errors: [String] = []
    
    func createNewAccount(completion: @escaping (Bool) -> Void) {
        errors.removeAll()
        
        if email.isEmpty {
            errors.append("Email cannot be empty")
        }
        
        if password.isEmpty {
            errors.append("Password cannot be empty")
        }
        
        if password != repeatPassword {
            errors.append("Passwords do not match")
        }
        
        if !errors.isEmpty {
            completion(false)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errors.append(error.localizedDescription)
                completion(false)
                return
            }
            
            if let photo = self.photo, let user = result?.user {
                Storage.storage().reference(withPath: user.uid)
                    .putData(photo.pngData()!, metadata: nil) { _, error in
                    if let error = error {
                        self.errors.append(error.localizedDescription)
                        completion(false)
                        return
                    }
                }
            }
            
            completion(true)
            return
        }
    }
}
