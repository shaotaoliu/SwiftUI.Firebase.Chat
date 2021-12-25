import SwiftUI

struct TestView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Hello World")
                .foregroundColor(.white)
                .padding()
                .background(.blue)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
