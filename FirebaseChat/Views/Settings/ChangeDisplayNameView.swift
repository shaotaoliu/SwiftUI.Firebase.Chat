import SwiftUI

struct ChangeDisplayNameView: View {
    @ObservedObject var vm: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Change Display Name")
                .font(.title2.bold())
                .padding()

            ChatTextField("New Display Name", text: $vm.newDisplayName)

            ChatButton("Submit") {
                vm.changeDisplayName()
            }
            
            Spacer()
        }
        .padding(20)
        .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in
        }, message: { messageText in
            Text(messageText)
        })
        .onDisappear {
            vm.newDisplayName = ""
        }
    }
}

struct ChangeDisplayNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeDisplayNameView(vm: SettingsViewModel())
    }
}
