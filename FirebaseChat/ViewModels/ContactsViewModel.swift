import Foundation

class ContactsViewModel: ViewModel {
    @Published var contacts: [UserModel] = []
    @Published var searchText: String = ""
    
    override init() {
        super.init()
        
        UserService.shared.getAll { users, error in
            self.contacts = users ?? []
        }
    }
    
    var filteredContacts: [UserModel] {
        var list: [UserModel] = []
        
        if searchText.isEmpty {
            list = contacts.filter {
                $0.id != AuthService.shared.currentUser?.uid
            }
        } else {
            list = contacts.filter {
                $0.id != AuthService.shared.currentUser?.uid && $0.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return list.sorted { $0.displayName < $1.displayName }
    }
}
