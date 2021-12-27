import SwiftUI

struct LoadingView: View {
    private let text: String?
    
    init(text: String? = nil) {
        self.text = text
    }
    
    var body: some View {
        ZStack {
            Color.primary
                .opacity(0.2)
                .ignoresSafeArea()
            
            VStack {
                Text(text ?? "Please wait ...")
                
                ProgressView()
            }
            .padding()
            .padding(.horizontal, 5)
            .frame(minWidth: 100)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
