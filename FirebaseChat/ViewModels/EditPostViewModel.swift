import SwiftUI

class EditPostViewModel: ViewModel {
    @Published var text: String = ""
    @Published var image: UIImage? = nil
    @Published var showImagePicker = false
    @Published var post: PostModel? = nil
    
    func loadPost(postVM: PostViewModel) {
        isLoading = true
        
        PostsService.shared.get(id: postVM.id) { post, error in
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                self.isLoading = false
                return
            }
            
            if post?.imageURL == nil {
                self.text = post?.text ?? ""
                self.post = post
                self.isLoading = false
                return
            }
            
            StorageService.shared.getImage(source: .post, id: postVM.id) { image, error in
                self.isLoading = false
                
                if let error = error {
                    self.setMessage(.error, error.localizedDescription)
                    return
                }
                
                self.text = post?.text ?? ""
                self.image = image
                self.post = post
            }
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        if text.isEmpty && image == nil {
            setMessage(.error, "Post cannot be empty.")
            completion(false)
            return
        }
        
        isLoading = true
        post!.text = text
        
        PostsService.shared.update(post: post!, image: image) { error in
            self.isLoading = false
            
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
