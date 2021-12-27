import SwiftUI

struct ChatButtonExample: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            ChatTextField("Username", text: $username)
            
            ChatTextField("Password", text: $password, isSecure: true)
            
            HStack(spacing: 20) {
                ChatButton("Cancel") {
                    username = "Cancel"
                }
                
                ChatButton("Save") {
                    username = "Save"
                }
            }
            
            ChatLink("Login") {
                username = "Login"
            }
        }
        .padding(.horizontal)
    }
}

struct ChatButton: View {
    let text: String
    let action: () -> Void
    
    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(8)
        })
    }
}

struct ChatTextField: View {
    let placeholder: String
    let text: Binding<String>
    let isSecure: Bool
    
    init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: text)
            }
            else {
                TextField(placeholder, text: text)
            }
        }
        .font(.system(size: 20))
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
    }
}

struct ChatLink: View {
    let text: String
    let action: () -> Void
    
    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(text) {
            action()
        }
        .font(.system(size: 20))
    }
}

struct ChatButton_Previews: PreviewProvider {
    static var previews: some View {
        ChatButtonExample()
    }
}
