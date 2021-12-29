import SwiftUI

class PostsViewModel: ViewModel {
    @Published var posts: [PostViewModel] = []
    @Published var showNewPostView = false
    
    override init() {
        super.init()
        loadPosts()
    }
    
    var sortedPosts: [PostViewModel] {
        posts.sorted {
            $0.postedDt > $1.postedDt
        }
    }
    
    func loadPosts() {
        isLoading = true
        posts.removeAll()
        
        PostsService.shared.getAll { postModels, error in
            if let error = error {
                self.isLoading = false
                self.setMessage(.error, error.localizedDescription)
                return
            }
            
            if let models = postModels {
                var count = 0
                self.posts.removeAll()
                
                for model in models {
                    UserService.shared.get(id: model.userId) { user, error in
                        self.posts.append(PostViewModel(
                            id: model.id!,
                            userId: model.userId,
                            userName: user?.displayName ?? "",
                            userPhotoURL: user?.photoURL ?? "",
                            text: model.text,
                            imageURL: model.imageURL,
                            postedDt: model.postedDt.longString(today: true)))
                        
                        count += 1
                        if count == models.count {
                            self.isLoading = false
                        }
                    }
                }
            }
        }
    }
    
    func delete(postVM: PostViewModel) {
        isLoading = true
        let model = PostModel(id: postVM.id, userId: postVM.userId, text: postVM.text, imageURL: postVM.imageURL, postedDt: Date())
        
        PostsService.shared.delete(post: model) { error in
            self.isLoading = false
            
            if let error = error {
                self.setMessage(.error, error.localizedDescription)
                return
            }
        }
    }
    
    func editPost(post: PostViewModel) {
        
    }
}

struct PostViewModel {
    var id: String
    var userId: String
    var userName: String
    var userPhotoURL: String?
    var text: String
    var imageURL: String?
    var postedDt: String
}

