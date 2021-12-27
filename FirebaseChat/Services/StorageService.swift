import SwiftUI
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    private let photoRef = Storage.storage().reference().child("photos")
    private let imageRef = Storage.storage().reference().child("images")
    
    private init() {
        
    }
    
    func storeUserPhoto(userId: String, photo: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        let ref = photoRef.child(userId)
        
        ref.putData(photo.pngData()!, metadata: nil) { metadata, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(url, nil)
            }
        }
    }
    
    func getUserPhoto(userId: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let ref = photoRef.child(userId)
        
        ref.getData(maxSize: MAX_PHOTO_SIZE) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(UIImage(data: data!), nil)
            return
        }
    }
    
    func deleteUserPhoto(userId: String, completion: @escaping (Error?) -> Void) {
        photoRef.child(userId).delete { error in
            completion(error)
        }
    }
    
    func updateUserPhoto(userId: String, photo: UIImage, completion: @escaping (Error?) -> Void) {
        photoRef.child(userId).putData(photo.pngData()!, metadata: nil) { metadata, error in
            completion(error)
        }
    }
}
