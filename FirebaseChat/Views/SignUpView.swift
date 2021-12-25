import SwiftUI

struct SignUpView: View {
    @StateObject private var vm = SignUpViewModel()
    @FocusState var focusedField: LoginField?
    
    var body: some View {
        VStack {
            Text("Create New Account")
                .font(.title2.bold())
            
            Button(action: {
                vm.showImagePicker = true
            }, label: {
                VStack {
                    if let image = vm.photo {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                    }
                }
            })
                .padding(.vertical)
            
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
                
                SecureField("Repeat Password", text: $vm.repeatPassword)
                    .font(.system(size: 22))
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .repeatPassword)
            }
            .padding(.vertical)
            
            Button(action: {
                createNewAccount()
            }, label: {
                Text("Sign Up")
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
        }
        .padding()
        .fullScreenCover(isPresented: $vm.showImagePicker) {
            ImagePicker(image: $vm.photo)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                focusedField = .email
            })
        }
    }
    
    func createNewAccount() {
        vm.createNewAccount { success in
            if success {
                
            }
            else {
                if vm.email.isEmpty {
                    focusedField = .email
                }
                else if vm.password.isEmpty {
                    focusedField = .password
                }
                else if vm.repeatPassword.isEmpty {
                    focusedField = .repeatPassword
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
