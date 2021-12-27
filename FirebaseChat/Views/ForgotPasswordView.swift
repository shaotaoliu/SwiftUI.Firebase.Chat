import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = ForgotPasswordViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Reset Password")
                .font(.title2.bold())
            
            VStack {
                Text("Please enter your email address. An email will be sent to you to reset your password.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ChatTextField("Email", text: $vm.email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            ChatButton("Send Email") {
                vm.sendResetPasswordEmail()
            }
            
            Spacer()
        }
        .padding(20)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            VStack {
                if vm.isLoading {
                    LoadingView()
                }
            }
        )
        .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in
            Button("OK") {
                if vm.emailSent {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }, message: { messageText in
            Text(messageText)
        })
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
