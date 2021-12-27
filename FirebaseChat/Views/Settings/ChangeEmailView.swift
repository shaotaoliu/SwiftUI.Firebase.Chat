import SwiftUI

struct ChangeEmailView: View {
    @ObservedObject var vm: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Change Email")
                .font(.title2.bold())
                .padding()

            ChatTextField("New Email", text: $vm.newEmail)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            ChatButton("Submit") {
                vm.changeEmail()
            }
            
            Spacer()
        }
        .padding(20)
        .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in
            Button("OK") {
                if vm.messageType == .info {
                    vm.showChangeEmailView = false
                }
            }
        }, message: { messageText in
            Text(messageText)
        })
        .onDisappear {
            vm.newEmail = ""
        }
    }
}

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView(vm: SettingsViewModel())
    }
}
