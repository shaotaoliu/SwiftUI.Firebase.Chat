import Foundation

enum ChatError: String, LocalizedError {
    case emailNotVerified
    case createUserFailed
    case userNotLoggeddIn
    case newPasswordShouldBeDifferent
    case emailNotExists
    case postNotExists
    
    var errorDescription: String? {
        switch self {
        case .emailNotVerified:
            return NSLocalizedString("This email address has not been verified.", comment: "")
        case .createUserFailed:
            return NSLocalizedString("Failed to create user.", comment: "")
        case .userNotLoggeddIn:
            return NSLocalizedString("User is not logged in.", comment: "")
        case .newPasswordShouldBeDifferent:
            return NSLocalizedString("Please enter a new password different from current password.", comment: "")
        case .emailNotExists:
            return NSLocalizedString("The email address does not exist.", comment: "")
        case .postNotExists:
            return NSLocalizedString("The post does not exist.", comment: "")
        }
    }
}
