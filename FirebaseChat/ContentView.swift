import SwiftUI
import FirebaseStorage

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Save") {
                Storage.storage().reference().child("login").child("apple").child("2021").putData("Hello".data(using: .utf8)!, metadata: nil) { _, error in
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
