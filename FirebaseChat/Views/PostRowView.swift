import SwiftUI
import SDWebImageSwiftUI

struct PostRowView: View {
    @ObservedObject var vm: PostsViewModel
    var post: PostViewModel
    private let uid = AuthService.shared.currentUser!.uid
    @State private var showEditPostView = false
    
    var body: some View {
        VStack {
            HStack {
                if let photoURL = post.userPhotoURL {
                    WebImage(url: URL(string: photoURL)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                
                Text(post.userName)
                    .fontWeight(.bold)
                
                Spacer()
                
                if post.userId == uid {
                    Menu(content: {
                        Button("Edit") {
                            showEditPostView = true
                        }
                        
                        Button("Delete") {
                            vm.delete(postVM: post)
                        }
                    }, label: {
                        Image("menu")
                            .resizable()
                            .frame(width: 15, height: 15)
                    })
                }
            }
            
            if let imageURL = post.imageURL {
                WebImage(url: URL(string: imageURL)!)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 260)
                    .cornerRadius(10)
            }
            
            HStack {
                Text(post.text)
                
                Spacer(minLength: 0)
            }
            
            HStack {
                Spacer(minLength: 0)
                
                Text(post.postedDt)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .primary, radius: 2, x: 2, y: 2)
        .shadow(color: .primary.opacity(0.5), radius: 1, x: 0, y: 0)
        .fullScreenCover(isPresented: $showEditPostView) {
            EditPostView(post: post)
        }
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(vm: PostsViewModel(),
                    post: PostViewModel(
                        id: "123",
                        userId: "456",
                        userName: "Kevin",
                        userPhotoURL: nil,
                        text: "Hello",
                        imageURL: nil,
                        postedDt: Date().longString(today: true)))
    }
}
