import Foundation
import FirebaseAuth

class ResetPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var errors: [String] = []
    
    func sendResetPasswordEmail(completion: @escaping (Bool) -> Void) {
        errors.removeAll()
        
        if email.isEmpty {
            errors.append("Email cannot be empty")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errors.append(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
}
