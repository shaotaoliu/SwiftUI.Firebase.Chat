import SwiftUI
import FirebaseFirestoreSwift

struct PostModel: Codable {
    @DocumentID var id: String?
    var userId: String
    var text: String
    var imageURL: String?
    var postedDt: Date
}
