import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class HomeModel: ObservableObject {
    @Published var text = ""
    @Published var messages: [Message] = []
    
    init() {
        readMessages()
    }
    
    func readMessages() {
        Firestore.firestore().collection("messages").order(by: "timeStamp", descending: false)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snapshot!.documentChanges.forEach { snap in
                if snap.type == .added {
                    let message = try! snap.document.data(as: Message.self)!
                    DispatchQueue.main.async {
                        self.messages.append(message)
                    }
                }
            }
        }
    }
    
    func sendMessage() {
        let message = Message(text: self.text, userId: "1001", timeStamp: Date())
        
        let _ = try! Firestore.firestore().collection("messages").addDocument(from: message) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.text = ""
        }
    }
}

struct Message: Codable, Identifiable {
    @DocumentID var id : String?
    var text : String
    var userId : String
    var timeStamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case userId
        case timeStamp
    }
}


struct HomeView: View {
    @StateObject var vm = HomeModel()
    
    var body: some View {
        VStack(spacing: 20){
            HStack {
                TextField("Enter Message", text: $vm.text)
                    .textFieldStyle(.roundedBorder)
                
                Button("Send") {
                    vm.sendMessage()
                }
            }
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(vm.messages, id: \.id) { message in
                    Text(message.text)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
