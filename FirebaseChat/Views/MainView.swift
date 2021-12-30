import SwiftUI

struct MainView: View {
    @Binding var currentPage: ChatPage
    @State var selectedTab: ChatTab = .chats
    @State var showNewPostView = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ChatsView()
                    .tag(ChatTab.chats)
                    .tabItem {
                        VStack {
                            Image(systemName: "message.fill")
                            Text("Chats")
                        }
                    }
                
                ContactsView()
                    .tag(ChatTab.contacts)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.2.fill")
                            Text("Contacts")
                        }
                    }
                
                PostsView()
                    .tag(ChatTab.posts)
                    .tabItem {
                        VStack {
                            Image(systemName: "list.number")
                            Text("Posts")
                        }
                    }
                
                SettingsView(currentPage: $currentPage)
                    .tag(ChatTab.settings)
                    .tabItem {
                        VStack {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
            }
            .navigationTitle(selectedTab.rawValue.capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: TrailingBarItem)
            .fullScreenCover(isPresented: $showNewPostView) {
                NewPostView()
            }
        }
    }
    
    var TrailingBarItem: some View {
        Group {
            switch selectedTab {
            case .chats:
                EmptyView()
                
            case .contacts:
                EmptyView()
                
            case .posts:
                Button(action: {
                    showNewPostView = true
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 16))
                })
                
            case .settings:
                Button("Sign Out") {
                    Global.signOut()
                    currentPage = .loginView
                }
                .font(.system(size: 16))
            }
        }
    }
}

enum ChatTab: String {
    case chats
    case contacts
    case posts
    case settings
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(currentPage: .constant(.mainView))
    }
}
