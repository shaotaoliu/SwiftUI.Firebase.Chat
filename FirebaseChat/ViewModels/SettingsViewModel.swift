import SwiftUI

class SettingsViewModel: ViewModel {
    @Published var photo: UIImage? = nil
    @Published var newPhoto: UIImage? = nil
    @Published var showChangePhotoView = false
    @Published var showImagePicker = false
    
    @Published var displayName: String = ""
    @Published var newDisplayName: String = ""
    @Published var showChangeDisplayNameView = false
    
    @Published var email: String = ""
    @Published var newEmail: String = ""
    @Published var showChangeEmailView = false
    
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    @Published var showChangePasswordView = false
    
    @Published var showDeleteAccountView = false
    @Published var confirmDeleteAccount = false
    @Published var accountHasBeenDeleted = false
    
    override init() {
        super.init()
        
        if let user = AuthService.shared.currentUser {
            displayName = user.displayName ?? ""
            email = user.email ?? ""
            
            if user.photoURL != nil {
                StorageService.shared.getUserPhoto(userId: user.uid) { image, error in
                    self.photo = image
                }
            }
        }
    }
    
    func changePhoto() {
        guard let photo = newPhoto else {
            return
        }
        
        isLoading = true
        
        AuthService.shared.updatePhoto(photo: photo) { error in
            self.isLoading = false
            
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            self.photo = photo
            self.showChangePhotoView = false
        }
    }
    
    func changePassword() {
        if currentPassword.isEmpty {
            self.setMessage(.error, "Please enter current password.")
            return
        }
        
        if newPassword.isEmpty {
            self.setMessage(.error, "Please enter new password.")
            return
        }
        
        if newPassword != confirmNewPassword {
            self.setMessage(.error, "Confirm password does not match.")
            return
        }
        
        AuthService.shared.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            self.setMessage(.info, "Your password has been changed successfully.")
            return
        }
    }
    
    func deleteAccount() {
        self.isLoading = true
        
        AuthService.shared.deleteUser { error in
            self.isLoading = false
            
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            self.accountHasBeenDeleted = true
            self.setMessage(.info, "Your account has been deleted successfully. You can re-register it or switch to a different account if you have.")
            return
        }
    }
    
    func changeEmail() {
        if newEmail.isEmpty {
            self.setMessage(.error, "Please enter your new email address.")
            return
        }
        
        AuthService.shared.updateEmail(email: newEmail) { error in
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            self.email = self.newEmail
            self.setMessage(.info, "A verification email has been sent to your email address. Please follow the instructions to complete your registration.")
            return
        }
    }
    
    func changeDisplayName() {
        if newDisplayName.isEmpty {
            self.setMessage(.error, "Please enter your new display name.")
            return
        }
        
        AuthService.shared.updateDisplayName(displayName: newDisplayName) { error in
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            self.displayName = self.newDisplayName
            self.showChangeDisplayNameView = false
            return
        }
    }
}
