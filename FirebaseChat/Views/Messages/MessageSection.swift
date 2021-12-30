import SwiftUI
import SDWebImageSwiftUI

struct MessageSection: View {
    @ObservedObject var vm: MessagesViewModel
    let chatter: UserModel
    let viewWidth: CGFloat
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 0) {
            ForEach(vm.messages, id: \.id) { message in
                HStack(alignment: .top) {
                    HStack(alignment: .top) {
                        if !message.fromMe {
                            WebImage(url: URL(string: chatter.photoURL!)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .padding(.leading, 10)
                        }
                        
                        VStack(alignment: .trailing) {
                            if let text = message.text, !text.isEmpty {
                                Text(text)
                                    .padding(10)
                                    .background(message.fromMe ? Color.green.opacity(0.9) : Color.black.opacity(0.2))
                                    .clipShape(ChatBubble(corner: message.fromMe ? .topLeft : .topRight))
                            }
                            
                            if let url = message.imageURL {
                                WebImageView(url: url)
                            }
                            
                            Text(message.sentTime.longString())
                                .font(.caption)
                        }
                        
                        if message.fromMe {
                            WebImage(url: AuthService.shared.currentUser!.photoURL!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .padding(.trailing, 10)
                        }
                    }
                    .frame(width: viewWidth - 60, alignment: message.fromMe ? .trailing : .leading)
                    .padding(.vertical, 12)
                }
                .frame(maxWidth: .infinity, alignment: message.fromMe ? .trailing : .leading)
                .id(message.id)
            }
        }
    }
    
    let defaultPhoto: some View = Image(systemName: "person.crop.circle.fill")
        .resizable()
        .scaledToFill()
        .frame(width: 40, height: 40)
        .foregroundColor(.gray)
    
    struct WebImageView: View {
        let url: String
        @State private var showImageView = false
        @Namespace var animation
        
        var body: some View {
            WebImage(url: URL(string: url)!)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .cornerRadius(10)
                .onTapGesture {
                    withAnimation {
                        showImageView = true
                    }
                }
                .fullScreenCover(isPresented: $showImageView) {
                    ImageView(showImageView: $showImageView, url: url, namespace: animation)
                }
        }
    }
}

struct MessageSection_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            MessageSection(vm: MessagesViewModel(),
                           chatter: UserModel(id: "123", displayName: "Kevin", photoURL: nil, email: ""),
                           viewWidth: UIScreen.main.bounds.width)
        }
    }
}
