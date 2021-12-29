import SwiftUI

struct MainView: View {
    @Binding var currentPage: ChatPage
    @State var selectedTab: ChatTab = .chatView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChatView()
                .tag(ChatTab.chatView)
                .tabItem {
                    VStack {
                        Image(systemName: "message.fill")
                        Text("Chats")
                    }
                }
            
            ContactsView()
                .tag(ChatTab.contactsView)
                .tabItem {
                    VStack {
                        Image(systemName: "person.2.fill")
                        Text("Contacts")
                    }
                }
            
            PostsView()
                .tag(ChatTab.postsView)
                .tabItem {
                    VStack {
                        Image(systemName: "list.number")
                        Text("Posts")
                    }
                }
            
            SettingsView(currentPage: $currentPage)
                .tag(ChatTab.settingsView)
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                }
        }
    }
}

enum ChatTab {
    case chatView
    case contactsView
    case postsView
    case settingsView
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(currentPage: .constant(.mainView))
    }
}
