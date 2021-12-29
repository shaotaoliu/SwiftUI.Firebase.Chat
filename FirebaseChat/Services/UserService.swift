import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    private let collection = Firestore.firestore().collection("users")
    
    func save(user: UserModel, completion: @escaping (Error?) -> Void) {
        do {
            try collection.document(user.id!).setData(from: user)
            completion(nil)
        }
        catch {
            completion(error)
            return
        }
    }
    
    func getAll(completion: @escaping ([UserModel]?, Error?) -> Void) {
        collection.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([], nil)
                return
            }
            
            let users = documents.compactMap { try? $0.data(as: UserModel.self) }
            completion(users, nil)
        }
    }
    
    func get(id: String, completion: @escaping (UserModel?, Error?) -> Void) {
        collection.document(id).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists else {
                completion(nil, ChatError.emailNotExists)
                return
            }
            
            do {
                let user = try document.data(as: UserModel.self)
                completion(user, nil)
            }
            catch {
                completion(nil, error)
                return
            }
        }
    }
    
    func getByEmail(email: String, completion: @escaping (UserModel?, Error?) -> Void) {
        collection.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = snapshot?.documents.first else {
                completion(nil, ChatError.emailNotExists)
                return
            }
        
            do {
                let user = try document.data(as: UserModel.self)
                completion(user, nil)
            }
            catch {
                completion(nil, error)
                return
            }
        }
    }
    
    func delete(id: String, completion: @escaping (Error?) -> Void) {
        collection.document(id).delete() { error in
            completion(error)
        }
    }
}
