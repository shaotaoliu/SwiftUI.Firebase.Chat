import Foundation

class ForgotPasswordViewModel: ViewModel {
    @Published var email = ""
    @Published var emailSent = false
    
    func sendResetPasswordEmail() {
        emailSent = false
        
        if email.isEmpty {
            setMessage(.error, "Please enter email.")
            return
        }
        
        isLoading = true
        
        AuthService.shared.sendResetPasswordEmail(email: email) { error in
            self.isLoading = false
            
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            self.setMessage(.info, "A reset password email has been sent.")
            self.emailSent = true
            self.email = ""
        }
    }
}
