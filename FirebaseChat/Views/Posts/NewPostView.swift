import SwiftUI

struct NewPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = NewPostViewModel()
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
                
                Button(action: {
                    vm.showImagePicker = true
                }, label: {
                    Image(systemName: "photo.fill")
                        .font(.title2)
                })
                
                Button("Post") {
                    vm.save { posted in
                        if posted {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .padding(.leading, 10)
            }
            
            Text("New Post")
                .font(.title2.bold())
                .padding(.bottom)
            
            if let image = vm.image {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                    //Image("tipsoo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 260)
                        .cornerRadius(10)
                    
                    Button(action: {
                        vm.image = nil
                    }, label: {
                        Image(systemName: "xmark")
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(10)
                    })
                }
            }
            
            TextEditor(text: $vm.text)
                .cornerRadius(10)
                .shadow(color: .primary, radius: 5, x: 5, y: 5)
                .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal)
        .sheet(isPresented: $vm.showImagePicker) {
            ImagePicker(image: $vm.image)
        }
        .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in }, message: { messageText in
            Text(messageText)
        })
        .overlay(
            ZStack {
                if vm.isLoading {
                    LoadingView()
                }
            }
        )
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
