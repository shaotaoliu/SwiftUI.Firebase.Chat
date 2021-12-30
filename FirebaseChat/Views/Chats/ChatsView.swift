import SwiftUI

struct ChatsView: View {
    @StateObject var vm = ChatsViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            SearchBar(text: $vm.searchText, placeholder: "Search")
                .padding(.horizontal)
            
            List {
                ForEach(vm.filteredMessage, id: \.id) { message in
                    ZStack {
                        ChatRow(message: message)
                        
                        NavigationLink(destination: {
                            MessagesView(chatter: UserModel(id: message.id,
                                                            displayName: message.recipient.displayName,
                                                            photoURL: message.recipient.photoURL,
                                                            email: ""))
                        }, label: {
                            EmptyView()
                        })
                            .buttonStyle(.plain)
                            .frame(width: 0)
                            .opacity(0)
                    }
                    .swipeActions(edge: .trailing) {
                        if !message.alreadyRead {
                            Button("Mark as \nRead") {
                                vm.markRecentMessageAsRead(toId: message.id)
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
