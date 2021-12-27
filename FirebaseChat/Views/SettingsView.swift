import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsViewModel()
    @Binding var currentPage: ChatPage
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Settings")
                .font(.title2.bold())
            
            NavigationLink(isActive: $vm.showChangePhotoView, destination: {
                ChangePhotoView(vm: vm)
            }, label: {
                PhotoView(photo: vm.photo, width: 200)
                    .padding(.vertical, 20)
                    .onTapGesture {
                        vm.showChangePhotoView = true
                    }
            })
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Display Name".uppercased())
                        .foregroundColor(.gray)
                        .padding(.leading)
                    
                    ChatEditText(vm.displayName)
                }
                .onTapGesture {
                    vm.showChangeDisplayNameView = true
                }
                .sheet(isPresented: $vm.showChangeDisplayNameView) {
                    ChangeDisplayNameView(vm: vm)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email".uppercased())
                        .foregroundColor(.gray)
                        .padding(.leading)
                    
                    ChatEditText(vm.email)
                }
                .onTapGesture {
                    vm.showChangeEmailView = true
                }
                .sheet(isPresented: $vm.showChangeEmailView) {
                    ChangeEmailView(vm: vm)
                }
                
                Button("Change Password".uppercased()) {
                    vm.showChangePasswordView = true
                }
                .padding()
                .sheet(isPresented: $vm.showChangePasswordView) {
                    ChangePasswordView(vm: vm)
                }
                
                Spacer()
                
                Button("Delete Account".uppercased()) {
                    vm.showDeleteAccountView = true
                }
                .foregroundColor(.red)
                .padding()
                .sheet(isPresented: $vm.showDeleteAccountView) {
                    DeleteAccountView(vm: vm)
                        .onDisappear {
                            if vm.accountHasBeenDeleted {
                                currentPage = .loginView
                            }
                        }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.15))
        }
        .navigationBarTitleDisplayMode(.inline)
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
