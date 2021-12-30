import SwiftUI

struct MessagesView: View {
    @StateObject var vm = MessagesViewModel()
    let chatter: UserModel
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ScrollView {
                    ScrollViewReader { reader in
                        MessageSection(vm: vm, chatter: chatter, viewWidth: proxy.size.width)
                            .onChange(of: vm.latestMessageId) { _ in
                                if let messageId = vm.latestMessageId {
                                    scrollTo(proxy: reader, messageId: messageId, shouldAnimate: true)
                                }
                            }
                            .onAppear {
                                if let messageId = vm.latestMessageId {
                                    scrollTo(proxy: reader, messageId: messageId, shouldAnimate: false)
                                }
                            }
                    }
                }
            }
            .padding(.bottom, 5)
            
            MessageBar(vm: vm, chatter: chatter)
        }
        .navigationTitle(chatter.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.getMessages(toId: chatter.id!)
        }
    }
    
    func scrollTo(proxy: ScrollViewProxy, messageId: String, shouldAnimate: Bool) {
        DispatchQueue.main.async {
            withAnimation(shouldAnimate ? .easeIn : nil) {
                proxy.scrollTo(messageId, anchor: .bottom)
            }
            
            vm.markRecentMessageAsRead(toId: chatter.id!)
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(chatter: UserModel(id: "123", displayName: "Kevin", photoURL: nil, email: ""))
    }
}
