import SwiftUI

struct ChatView: View {
    var body: some View {
        Text(AuthService.shared.currentUser?.displayName ?? "No Login")
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
