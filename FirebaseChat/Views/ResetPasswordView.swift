import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var vm = ResetPasswordViewModel()
    @FocusState var focusOnEmail
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Reset Password")
                .font(.title2.bold())
            
            VStack {
                Text("Please enter your email address. An email will be sent to you to reset your password.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Email", text: $vm.email)
                .font(.system(size: 22))
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .focused($focusOnEmail)
            
            Button {
                sendEmail()
            } label: {
                Text("Send Email")
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
            }
            .font(.system(size: 22))
            .foregroundColor(.white)
            .background(vm.email.isEmpty ? Color.gray : Color.blue)
            .cornerRadius(10)
            .disabled(vm.email.isEmpty)
            
            ErrorsView(errors: vm.errors)
            
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                focusOnEmail = true
            })
        }
    }
    
    func sendEmail() {
        vm.sendResetPasswordEmail { success in
            if success {
                vm.email = ""
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
