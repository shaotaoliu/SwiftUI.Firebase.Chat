import SwiftUI
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    private init() {
        
    }
    
    var currentUser: User? {
        auth.currentUser
    }
    
    func signUp(email: String, password: String, displayName: String, photo: UIImage?, completion: @escaping (Error?) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let user = result?.user else {
                completion(ChatError.createUserFailed)
                return
            }
            
            guard let photo = photo else {
                self.saveExtraInfo(user: user, displayName: displayName, completion: completion)
                return
            }
            
            StorageService.shared.storeUserPhoto(userId: user.uid, photo: photo) { url, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                print(url!.absoluteString)
                self.saveExtraInfo(user: user, displayName: displayName, photoURL: url, completion: completion)
            }
        }
    }
    
    private func saveExtraInfo(user: User, displayName: String? = nil, photoURL: URL? = nil, completion: @escaping (Error?) -> Void) {
        let request = user.createProfileChangeRequest()
        
        if let displayName = displayName {
            request.displayName = displayName
        }
        
        if let url = photoURL {
            request.photoURL = url
        }
        
        request.commitChanges { error in
            if let error = error {
                completion(error)
                return
            }
            
            
            UserService.shared.save(user: UserModel(from: user)) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                user.sendEmailVerification { error in
                    completion(error)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let user = result?.user else {
                completion(error)
                return
            }
            
            if !user.isEmailVerified {
                completion(ChatError.emailNotVerified)
                return
            }
            
            completion(nil)
            return
        }
    }
    
    func signOut() {
        try? auth.signOut()
    }
    
    func sendResetPasswordEmail(email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            return
        }
    }
    
    func updatePhoto(photo: UIImage, completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser else {
            completion(ChatError.userNotLoggeddIn)
            return
        }
        
        StorageService.shared.storeUserPhoto(userId: user.uid, photo: photo) { url, error in
            if let error = error {
                completion(error)
                return
            }
            
            self.saveExtraInfo(user: user, photoURL: url, completion: completion)
        }
    }
    
    func updateDisplayName(displayName: String, completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser else {
            completion(ChatError.userNotLoggeddIn)
            return
        }
        
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        
        request.commitChanges { error in
            if let error = error {
                completion(error)
                return
            }
            
            UserService.shared.save(user: UserModel(from: user)) { error in
                completion(error)
            }
        }
    }
    
    func updateEmail(email: String, completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser else {
            completion(ChatError.userNotLoggeddIn)
            return
        }
        
        user.updateEmail(to: email) { error in
            if let error = error {
                completion(error)
                return
            }
            
            UserService.shared.save(user: UserModel(from: user)) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                user.sendEmailVerification { error in
                    completion(error)
                }
            }
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser else {
            completion(ChatError.userNotLoggeddIn)
            return
        }
        
        auth.signIn(withEmail: user.email!, password: currentPassword) { _, error in
            if let error = error {
                completion(error)
                return
            }
            
            if currentPassword == newPassword {
                completion(ChatError.newPasswordShouldBeDifferent)
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                completion(error)
            }
        }
    }
    
    func deleteUser(completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser else {
            completion(ChatError.userNotLoggeddIn)
            return
        }
        
        if user.photoURL == nil {
            deleteFromFirestore(user: user, completion: completion)
            return
        }
        
        StorageService.shared.deleteUserPhoto(userId: user.uid) { error in
            if let error = error {
                completion(error)
                return
            }
            
            self.deleteFromFirestore(user: user, completion: completion)
            return
        }
    }
    
    private func deleteFromFirestore(user: User, completion: @escaping (Error?) -> Void) {
        UserService.shared.delete(id: user.uid) { error in
            if let error = error {
                completion(error)
                return
            }
            
            user.delete { error in
                completion(error)
            }
        }
    }
}
