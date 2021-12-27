import SwiftUI

struct ChangePhotoView: View {
    @ObservedObject var vm: SettingsViewModel
    private let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            PhotoView(photo: vm.newPhoto, width: width)
                .onTapGesture {
                    vm.showImagePicker = true
                }
                .fullScreenCover(isPresented: $vm.showImagePicker) {
                    ImagePicker(image: $vm.newPhoto)
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Save") {
            vm.changePhoto()
        })
        .overlay(
            ZStack {
                if vm.isLoading {
                    LoadingView()
                }
            }
        )
        .onAppear {
            vm.newPhoto = vm.photo
        }
    }
}

struct ChangePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePhotoView(vm: SettingsViewModel())
    }
}
