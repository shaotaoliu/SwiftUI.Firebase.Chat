import SwiftUI

struct MainView: View {
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        VStack {
            Text(vm.email)
                .font(.title2.bold())
                .padding(.vertical)
            
            VStack {
                if let image = vm.photo {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                }
                else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
