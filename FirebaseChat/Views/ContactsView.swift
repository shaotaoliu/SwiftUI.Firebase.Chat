import SwiftUI
import SDWebImageSwiftUI

struct ContactsView: View {
    @StateObject var vm = ContactsViewModel()
    private let imageWidth: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Contacts")
                .font(.title2.bold())
            
            List {
                ForEach(vm.contacts, id: \.id) { contact in
                    HStack {
                        ZStack {
                            if let url = contact.photoURL {
                                WebImage(url: URL(string: url)!)
                                    .resizable()
                                    .placeholder {
                                        Image(systemName: "hourglass")
                                    }
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageWidth)
                                    .clipShape(Circle())
                            }
                            else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageWidth, height: imageWidth)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                        
                        Text(contact.displayName)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            ZStack {
                if vm.isLoading {
                    LoadingView()
                }
            }
        )
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
