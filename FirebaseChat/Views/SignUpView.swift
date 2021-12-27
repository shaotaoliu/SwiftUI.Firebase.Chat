import SwiftUI

struct SignUpView: View {
    @StateObject private var vm = SignUpViewModel()
    @Binding var currentPage: ChatPage
    @Binding var currentEmail: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Create New Account")
                .font(.title2.bold())
            
            PhotoView(photo: vm.photo, width: 200)
                .onTapGesture {
                    vm.showImagePicker = true
                }
                .fullScreenCover(isPresented: $vm.showImagePicker) {
                    ImagePicker(image: $vm.photo)
                }

            VStack(spacing: 15) {
                ChatTextField("Display Name", text: $vm.displayName)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                
                ChatTextField("Email", text: $vm.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    .keyboardType(.emailAddress)

                ChatTextField("Password", text: $vm.password, isSecure: true)
                    .autocapitalization(.none)

                ChatTextField("Confirm Password", text: $vm.confirmPassword, isSecure: true)
                    .autocapitalization(.none)
            }

            ChatButton("Sign Up") {
                vm.signUp()
            }
            
            ChatLink("Login") {
                withAnimation {
                    currentPage = .loginView
                    currentEmail = ""
                }
            }
            
            Spacer()
        }
        .padding(20)
        .overlay(
            ZStack {
                if vm.isLoading {
                    LoadingView()
                }
            }
        )
        .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in
            Button("OK") {
                if vm.signUpPassed {
                    withAnimation {
                        currentPage = .loginView
                        currentEmail = vm.email
                    }
                }
            }
        }, message: { messageText in
            Text(messageText)
        })
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(currentPage: .constant(.signUpView), currentEmail: .constant(""))
    }
}
