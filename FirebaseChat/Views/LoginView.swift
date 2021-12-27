import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    @Binding var currentPage: ChatPage
    @Binding var currentEmail: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Log In")
                    .font(.title2.bold())
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 30)
                
                VStack(spacing: 15) {
                    ChatTextField("Email", text: $vm.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                    
                    ChatTextField("Password", text: $vm.password, isSecure: true)
                        .autocapitalization(.none)
                }
                
                ChatButton("Sign In") {
                    vm.login(success: {
                        currentPage = .mainView
                    })
                }
                
                ChatLink("Sign Up") {
                    withAnimation {
                        currentPage = .signUpView
                    }
                }
                
                Spacer()
                
                NavigationLink("Forgot Password?", destination: {
                    ForgotPasswordView()
                })
                    .font(.system(size: 20))
            }
            .padding(20)
            .navigationBarHidden(true)
            .opacity(vm.isLoading ? 0.5 : 1.0)
            .overlay(
                ZStack {
                    if vm.isLoading {
                        ProgressView()
                    }
                }
            )
            .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in
                
            }, message: { messageText in
                Text(messageText)
            })
            .onAppear {
                vm.email = currentEmail
                currentEmail = ""
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(currentPage: .constant(.loginView), currentEmail: .constant(""))
    }
}
