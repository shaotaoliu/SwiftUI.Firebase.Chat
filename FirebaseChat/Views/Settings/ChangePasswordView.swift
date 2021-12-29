import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var vm: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Change Password")
                .font(.title2.bold())

            VStack(spacing: 15) {
                ChatTextField("Current Password", text: $vm.currentPassword, isSecure: true)
                    .autocapitalization(.none)
                
                ChatTextField("New Password", text: $vm.newPassword, isSecure: true)
                    .autocapitalization(.none)

                ChatTextField("Confirm Password", text: $vm.confirmNewPassword, isSecure: true)
                    .autocapitalization(.none)
            }

            ChatButton("Submit") {
                vm.changePassword()
            }
            
            Spacer()
        }
        .padding(20)
        .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in
            Button("OK") {
                if vm.messageType == .info {
                    vm.activeSheet = nil
                }
            }
        }, message: { messageText in
            Text(messageText)
        })
        .onDisappear {
            vm.currentPassword = ""
            vm.newPassword = ""
            vm.confirmNewPassword = ""
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(vm: SettingsViewModel())
    }
}
