import SwiftUI

struct PostsView: View {
    @StateObject var vm = PostsViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(vm.sortedPosts, id: \.id) { post in
                    PostRowView(vm: vm, post: post)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(vm: PostsViewModel())
    }
}
