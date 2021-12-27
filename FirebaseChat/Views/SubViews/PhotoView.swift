import SwiftUI

struct PhotoView: View {
    let photo: UIImage?
    let width: CGFloat
    let height: CGFloat?
    
    init(photo: UIImage? = nil, width: CGFloat, height: CGFloat? = nil) {
        self.photo = photo
        self.width = width
        self.height = height ?? width
    }
    
    var body: some View {
        VStack {
            if let image = photo {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
            }
            else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            PhotoView(width: 200)
            PhotoView(photo: UIImage(named: "tipsoo")!, width: 200)
        }
    }
}
