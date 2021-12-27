import SwiftUI

class LoginViewModel: ViewModel {
    @Published var email = ""
    @Published var password = ""
    
    func login(success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        if let errorMessage = validate() {
            setMessage(.error, errorMessage)
            failure?()
            return
        }
        
        isLoading = true
        
        AuthService.shared.signIn(email: email, password: password) { error in
            self.isLoading = false
            
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                failure?()
                return
            }
            
            self.email = ""
            self.password = ""
            
            success?()
            return
        }
    }
    
    private func validate() -> String? {
        if email.isEmpty {
            return "Please enter email."
        }

        if password.isEmpty {
            return "Please enter password."
        }

        return nil
    }
}

