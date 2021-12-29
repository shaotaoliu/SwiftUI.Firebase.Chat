import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class PostsService {
    static let shared = PostsService()
    
    private init() {}
    
    private let collection = Firestore.firestore().collection("posts")
    
    func create(text: String, image: UIImage?, completion: @escaping (Error?) -> Void) {
        let newPost = PostModel(id: nil, userId: AuthService.shared.currentUser!.uid, text: text, imageURL: nil, postedDt: Date())
        let newDocument = collection.document()
        
        do {
            try newDocument.setData(from: newPost)
        }
        catch {
            completion(error)
            return
        }
        
        guard let image = image else {
            completion(nil)
            return
        }

        StorageService.shared.storeImage(source: .post, id: newDocument.documentID, image: image) { url, error in
            if let error = error {
                completion(error)
                return
            }
            
            newDocument.updateData(["imageURL": url!.absoluteString]) { error in
                completion(error)
            }
        }
    }
    
    func update(post: PostModel, image: UIImage? = nil, completion: @escaping (Error?) -> Void) {
        if image == nil && post.imageURL != nil {
            StorageService.shared.deleteImage(source: .post, id: post.id!) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.collection.document(post.id!).updateData([
                    "imageURL": FieldValue.delete(),
                    "text": post.text,
                    "postedDt": Date()
                ]) { error in
                    completion(error)
                    return
                }
            }
            
            return
        }
        
        guard let image = image else {
            self.collection.document(post.id!).updateData([
                "imageURL": FieldValue.delete(),
                "text": post.text,
                "postedDt": Date()
            ]) { error in
                completion(error)
                return
            }
            
            return
        }

        StorageService.shared.storeImage(source: .post, id: post.id!, image: image) { url, error in
            if let error = error {
                completion(error)
                return
            }
            
            self.collection.document(post.id!).updateData([
                "imageURL": url!.absoluteString,
                "text": post.text,
                "postedDt": Date()
            ]) { error in
                completion(error)
            }
        }
    }
    
    func getAll(completion: @escaping ([PostModel]?, Error?) -> Void) {
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([], nil)
                return
            }
            
            let posts = documents.compactMap { try? $0.data(as: PostModel.self) }
            completion(posts, nil)
        }
    }
    
    func delete(post: PostModel, completion: @escaping (Error?) -> Void) {
        if post.imageURL == nil {
            collection.document(post.id!).delete() { error in
                completion(error)
            }
            
            return
        }
        
        StorageService.shared.deleteImage(source: .post, id: post.id!) { error in
            if let error = error {
                completion(error)
                return
            }
            
            self.collection.document(post.id!).delete() { error in
                completion(error)
            }
        }
    }
    
    func get(id: String, completion: @escaping (PostModel?, Error?) -> Void) {
        collection.document(id).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists {
                do {
                    let post = try document.data(as: PostModel.self)
                    completion(post, nil)
                }
                catch {
                    completion(nil, error)
                    return
                }
            }
            else {
                completion(nil, ChatError.postNotExists)
            }
        }
    }
}
