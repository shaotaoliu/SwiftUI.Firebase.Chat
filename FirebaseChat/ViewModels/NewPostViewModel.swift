import SwiftUI

class NewPostViewModel: ViewModel {
    @Published var text: String = ""
    @Published var image: UIImage? = nil
    @Published var showImagePicker = false
    
    func save(completion: @escaping (Bool) -> Void) {
        if text.isEmpty && image == nil {
            setMessage(.error, "Post cannot be empty.")
            completion(false)
            return
        }
        
        isLoading = true
        
        PostsService.shared.create(text: text, image: image) { error in
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
