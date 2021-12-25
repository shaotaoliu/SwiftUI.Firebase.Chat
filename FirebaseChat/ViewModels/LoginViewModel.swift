import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showMainView = false
    @Published var showSignUpView = false
    @Published var showResetPasswordView = false
    @Published var errors: [String] = []
    
    func login(completion: @escaping (Bool) -> Void) {
        errors.removeAll()
        
        if email.isEmpty {
            errors.append("Email cannot be empty")
        }
        
        if password.isEmpty {
            errors.append("Password cannot be empty")
        }
        
        if !errors.isEmpty {
            completion(false)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errors.append(error.localizedDescription)
                completion(false)
                return
            }
            
            self.email = ""
            self.password = ""
            
            completion(true)
            return
        }
    }
}
