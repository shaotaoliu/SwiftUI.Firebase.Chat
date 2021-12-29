import SwiftUI

struct MessagesView: View {
    @StateObject var vm = MessagesViewModel()
    let chatter: UserModel
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ScrollView {
                    ScrollViewReader { reader in
                        Text("Hello")
//                        MessageView(chat: chat, viewWidth: proxy.size.width)
//                            .onChange(of: scrollMessageId) { _ in
//                                if let messageId = scrollMessageId {
//                                    scrollTo(scrollReader: reader, messageId: messageId, shouldAnimate: true)
//                                }
//                            }
//                            .onAppear {
//                                if let messageId = chat.messages.last?.id {
//                                    scrollTo(scrollReader: reader, messageId: messageId, shouldAnimate: false)
//                                }
//                            }
                    }
                }
            }
            .padding(.bottom, 5)
            
            MessageBar(vm: vm, chatter: chatter)
        }
        .navigationTitle(chatter.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(chatter: UserModel(id: "123", displayName: "Kevin", photoURL: nil, email: ""))
    }
}
