import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    @Binding var showImageView: Bool
    let url: String
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            if showImageView {
                Color.primary
                    .ignoresSafeArea()
                
                WebImage(url: URL(string: url)!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .matchedGeometryEffect(id: url, in: namespace)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                showImageView = false
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        ImageView(showImageView: .constant(true), url: "", namespace: namespace)
    }
}
