import SwiftUI

struct ChatBubble: Shape {
    var corner: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let corners: UIRectCorner = [corner, .bottomLeft, .bottomRight]
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: 10, height: 10))
        
        return Path(path.cgPath)
    }
}
