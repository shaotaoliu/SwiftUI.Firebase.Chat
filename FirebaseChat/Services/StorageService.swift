import SwiftUI
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    private let reference = Storage.storage().reference()
    
    private init() {}
    
    func storeImage(source: ImageSource, id: String, image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        let ref = reference.child(source.rawValue).child(id)
        
        ref.putData(image.pngData()!, metadata: nil) { metadata, error in
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
    
    func getImage(source: ImageSource, id: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let ref = reference.child(source.rawValue).child(id)
        
        ref.getData(maxSize: MAX_PHOTO_SIZE) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(UIImage(data: data!), nil)
            return
        }
    }
    
    func deleteImage(source: ImageSource, id: String, completion: @escaping (Error?) -> Void) {
        let ref = reference.child(source.rawValue).child(id)
        
        ref.delete { error in
            completion(error)
        }
    }
}
