import SwiftUI

struct DeleteAccountView: View {
    @ObservedObject var vm: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Delete Account")
                .font(.title2.bold())
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Text("NOTE: ").bold() + Text("Are you sure you want to delete your account? All your current data will be deleted permanently.")
                }
                .multilineTextAlignment(.leading)
                
                Label("No, I don't want to delete my account", systemImage: vm.confirmDeleteAccount ? "circle" : "record.circle")
                    .onTapGesture {
                        vm.confirmDeleteAccount.toggle()
                    }
                
                Label("Yes, I do want to delete my account", systemImage: vm.confirmDeleteAccount ? "record.circle" : "circle")
                    .onTapGesture {
                        vm.confirmDeleteAccount.toggle()
                    }
            }
            
            ChatButton("Delete") {
                vm.deleteAccount()
            }
            .disabled(!vm.confirmDeleteAccount)
            .opacity(vm.confirmDeleteAccount ? 1.0 : 0.5)
            .alert(vm.messageTitle, isPresented: $vm.hasMessage, presenting: vm.messageText, actions: { _ in
                Button("OK") {
                    if vm.accountHasBeenDeleted {
                        vm.showDeleteAccountView = false
                    }
                }
            }, message: { messageText in
                Text(messageText)
            })
            
            Spacer()
        }
        .font(.system(size: 20))
        .padding()
        .overlay(
            ZStack {
                if vm.isLoading {
                    LoadingView()
                }
            }
        )
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView(vm: SettingsViewModel())
    }
}
