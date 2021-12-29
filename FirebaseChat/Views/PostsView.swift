import SwiftUI

struct PostsView: View {
    @StateObject var vm = PostsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button(action: {
                    vm.showNewPostView = true
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                })
            }
            .padding(.trailing)
            
            Text("Posts")
                .font(.title2.bold())
                .padding(.bottom, 20)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(vm.sortedPosts, id: \.id) { post in
                        PostRowView(vm: vm, post: post)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 1)
            }
        }
        .fullScreenCover(isPresented: $vm.showNewPostView) {
            NewPostView()
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(vm: PostsViewModel())
    }
}
