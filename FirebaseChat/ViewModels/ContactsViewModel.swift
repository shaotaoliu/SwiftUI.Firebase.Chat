import Foundation

class ContactsViewModel: ViewModel {
    @Published var contacts: [UserModel] = []
    
    override init() {
        super.init()
        
        UserService.shared.getAll { users, error in
            self.contacts = users ?? []
        }
    }
}
