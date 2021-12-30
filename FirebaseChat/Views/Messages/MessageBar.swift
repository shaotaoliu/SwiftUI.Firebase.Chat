import SwiftUI

struct MessageBar: View {
    @ObservedObject var vm: MessagesViewModel
    let chatter: UserModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: {
                    vm.showImagePicker = true
                }, label: {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                })
                
                TextField("Message...", text: $vm.textToSend, onCommit: {
                    sendMessage()
                })
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.send)
                
                Button(action: {
                    sendMessage()
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(nothingToSend() ? .gray.opacity(0.6) : .blue)
                })
                    .disabled(nothingToSend())
            }
            
            if let image = vm.imageToSend {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 266, height: 185)
                        .cornerRadius(10)
                    
                    Button(action: {
                        withAnimation {
                            vm.imageToSend = nil
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .padding(10)
                    })
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .fullScreenCover(isPresented: $vm.showImagePicker) {
            ImagePicker(image: $vm.imageToSend)
        }
    }
    
    func sendMessage() {
        vm.sendMessage(toId: chatter.id!)
    }
    
    func nothingToSend() -> Bool {
        return vm.textToSend.isEmpty && vm.imageToSend == nil
    }
}

struct MessageBar_Previews: PreviewProvider {
    static var previews: some View {
        MessageBar(vm: MessagesViewModel(),
                   chatter: UserModel(id: "123", displayName: "Kevin", photoURL: nil, email: ""))
    }
}
