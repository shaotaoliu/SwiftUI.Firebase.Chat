import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsViewModel()
    @Binding var currentPage: ChatPage
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(isActive: $vm.showChangePhotoView, destination: {
                ChangePhotoView(vm: vm)
            }, label: {
                PhotoView(photo: vm.photo, width: 200)
                    .padding(.vertical, 20)
                    .onTapGesture {
                        vm.showChangePhotoView = true
                    }
            })
                .padding(.bottom, 10)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Display Name".uppercased())
                        .foregroundColor(.gray)
                        .padding(.leading)
                    
                    ChatEditText(vm.displayName)
                }
                .onTapGesture {
                    vm.activeSheet = .displayName
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email".uppercased())
                        .foregroundColor(.gray)
                        .padding(.leading)
                    
                    ChatEditText(vm.email)
                }
                .onTapGesture {
                    vm.activeSheet = .email
                }
                
                Button("Change Password".uppercased()) {
                    vm.activeSheet = .password
                }
                .padding()
                
                Spacer()
                
                Button("Delete Account".uppercased()) {
                    vm.activeSheet = .delete
                }
                .foregroundColor(.red)
                .padding()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.15))
            .sheet(item: $vm.activeSheet) { activeSheet in
                switch activeSheet {
                case .displayName:
                    ChangeDisplayNameView(vm: vm)
                    
                case .email:
                    ChangeEmailView(vm: vm)
                    
                case .password:
                    ChangePasswordView(vm: vm)
                    
                case .delete:
                    DeleteAccountView(vm: vm)
                        .onDisappear {
                            if vm.accountHasBeenDeleted {
                                currentPage = .loginView
                            }
                        }
                }
            }
        }
    }
}

struct ChatEditText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(10)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(currentPage: .constant(.mainView))
    }
}
