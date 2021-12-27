import SwiftUI

class SignUpViewModel: ViewModel {
    @Published var displayName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var photo: UIImage? = nil
    @Published var showImagePicker = false
    @Published var signUpPassed = false
    
    func signUp() {
        signUpPassed = false
        
        if let errorMessage = validate() {
            self.setMessage(.error, errorMessage)
            return
        }
        
        self.isLoading = true

        AuthService.shared.signUp(email: email, password: password, displayName: displayName, photo: photo) { error in
            self.isLoading = false
            
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            // The user needs to re-login
            AuthService.shared.signOut()
            
            self.signUpPassed = true
            self.setMessage(.info, "A verification email has been sent to your email address. Please follow the instructions to complete your registration.")
        }
    }
    
    private func validate() -> String? {
        if displayName.isEmpty {
            return "Please enter dispaly name."
        }
        
        if email.isEmpty {
            return "Please enter email."
        }

        if password.isEmpty {
            return "Please enter password."
        }

        if password != confirmPassword {
            return "Confirm password does not match."
        }
        
        if let data = photo?.pngData(), data.count > MAX_PHOTO_SIZE {
            return "The Image is too large. The size should be less than 5 MB."
        }
        
        return nil
    }
}
