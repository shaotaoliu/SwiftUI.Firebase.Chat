import SwiftUI
import FirebaseStorage

struct ContentView: View {
    @State var currentPage: ChatPage
    @State var currentEmail: String = ""
    
    var body: some View {
        VStack {
            switch currentPage {
                
            case .loginView:
                
                LoginView(currentPage: $currentPage, currentEmail: $currentEmail)
                
            case .signUpView:
                
                SignUpView(currentPage: $currentPage, currentEmail: $currentEmail)
                
            case .mainView:
                
                MainView(currentPage: $currentPage)
            }
        }
    }
}

enum ChatPage {
    case loginView
    case signUpView
    case mainView
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentPage: .loginView)
    }
}
