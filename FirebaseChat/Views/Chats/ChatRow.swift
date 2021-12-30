import SwiftUI
import SDWebImageSwiftUI

struct ChatRow: View {
    let message: RecentMessage
    
    var body: some View {
        HStack(spacing: 20) {
            if let url = message.recipient.photoURL {
                WebImage(url: URL(string: url)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                    .padding(.vertical, 3)
            }
            else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .foregroundColor(.gray)
                    .padding(.vertical, 3)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(message.recipient.displayName)
                        .bold()
                    
                    Spacer()
                    
                    Text(message.sentTime.shortString())
                        .font(.system(size: 14))
                }
                
                HStack() {
                    Text(message.text)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    if !message.alreadyRead {
                        Circle()
                            .fill(.blue)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(message: RecentMessage(
            id: "123",
            text: "Hello",
            sentTime: Date(),
            alreadyRead: false,
            recipient: MessageRecipient(displayName: "Kevin", photoURL: nil)))
            .padding()
    }
}
