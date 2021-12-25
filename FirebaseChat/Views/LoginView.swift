import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    @FocusState var focusedField: LoginField?
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MainView(), isActive: $vm.showMainView) { EmptyView() }
                NavigationLink(destination: SignUpView(), isActive: $vm.showSignUpView) { EmptyView() }
                NavigationLink(destination: ResetPasswordView(), isActive: $vm.showResetPasswordView) { EmptyView() }
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 30)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $vm.email)
                        .font(.system(size: 22))
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                    
                    SecureField("Password", text: $vm.password)
                        .font(.system(size: 22))
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .password)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    login()
                }, label: {
                    Text("Sign In")
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                })
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                
                if !vm.errors.isEmpty {
                    ErrorsView(errors: vm.errors)
                        .padding(.top)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button(action: {
                        vm.showSignUpView = true
                    }, label: {
                        Text("Sign Up")
                            .font(.title3)
                            .foregroundColor(.blue)
                    })
                    
                    Button(action: {
                        vm.showResetPasswordView = true
                    }, label: {
                        Text("Forgot Password?")
                            .font(.title3)
                            .foregroundColor(.blue)
                    })
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                focusedField = .email
            })
        }
    }
    
    func login() {
        vm.login() { success in
            if success {
                vm.showMainView = true
            }
            else {
                if vm.email.isEmpty {
                    focusedField = .email
                }
                else if vm.password.isEmpty {
                    focusedField = .password
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
