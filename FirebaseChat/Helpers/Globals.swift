import Foundation

let MAX_PHOTO_SIZE: Int64 = 1024 * 1024 * 5       // 5 MB

class Global {
    static func signOut() {
        if AuthService.shared.currentUser != nil {
            AuthService.shared.signOut()
        }
    }

    static var isLoggedIn: Bool {
        return AuthService.shared.currentUser != nil
    }
}
