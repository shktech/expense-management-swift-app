import SwiftUI
import PhotosUI
import UIKit

enum FileAction {
    case downloadView, delete, add
}

struct FilePickerButton: View {
    let allowEdit: Bool
    
    @Binding var selectedFileURL: URL?
    @Binding var isShowingFilePicker: Bool
    @Binding var isShowingImagePicker: Bool
    @Binding var isShowingActionSheet: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var isEditable: Bool
    
    @State private var fileAction: FileAction?
    @State private var imagePreview: Bool?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Attached receipt")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            
            if selectedFileURL != nil {
                ZStack {
                    AsyncImage(url: selectedFileURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            VStack {
                                HStack{
                                    Text(selectedFileURL?.lastPathComponent.truncatedFilename(to: 20) ?? "Upload file")
                                        .foregroundStyle(.gray)
                                    closeButton
                                }
                                image
                                    .resizable()
                                    .edgesIgnoringSafeArea(.all)
                                    .scaledToFit()
                            }
                        case .failure:
                            VStack {
                                fileHader
                                filePicker
                            }
                        @unknown default:
                            VStack {
                                fileHader
                                filePicker
                            }
                        }
                    }
                }
                .frame(maxHeight: 400)
            } else {
                filePicker
            }
        }
        .sheet(isPresented: $isShowingFilePicker) {
            FilePicker(selectedFileURL: $selectedFileURL)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedFileURL: $selectedFileURL)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Download Completed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
            ActionSheet(title: Text("Upload Receipt"), message: nil, buttons: actionSheetButtons)
        }
    }
    
    var fileHader: some View {
        HStack {
            Text(selectedFileURL?.lastPathComponent.truncatedFilename(to: 20) ?? "Upload file")
                .foregroundStyle(.gray)
            closeButton
        }
        .padding(.vertical)
    }
    
    var filePicker: some View {
        Button(action: {
            isShowingActionSheet.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.gray)
                    .frame(height: 60)
                VStack {
                    Image(systemName: "doc")
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                    Text(selectedFileURL?.lastPathComponent.truncatedFilename(to: 20) ?? "Upload file")
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .disabled(!isEditable)
    }
    
    var closeButton: some View {
        Button(action: {
            deleteFile()
        }) {
            Image(systemName: "xmark.circle")
                .offset(x: 5, y: -10)
                .foregroundColor(.oceanBlue)
                .fontWeight(.semibold)
        }
            .frame(maxWidth: 100, alignment: .trailing)
            .opacity(allowEdit ? 1 : 0)
    }
    
    private var actionSheetButtons: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        if selectedFileURL == nil {
            buttons.append(.default(Text("Take Photo")) {
                showImagePicker(sourceType: .camera)
            })
            buttons.append(.default(Text("Photo Library")) {
                showImagePicker(sourceType: .photoLibrary)
            })
            buttons.append(.default(Text("Browse")) {
                isShowingFilePicker = true
            })
        }
        
        buttons.append(.cancel())
        
        return buttons
    }
    
    private func handleAction() {
        guard let action = fileAction else { return }
        
        switch action {
        case .downloadView:
            downloadAndViewFile()
        case .delete:
            deleteFile()
        case .add:
            addNewFile()
        }
    }
    
    private func downloadAndViewFile() {
        guard let url = selectedFileURL else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.saveImageToGallery(imageData: data)
                }
            } else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    private func deleteFile() {
        selectedFileURL = nil
        imagePreview = false
    }
    
    private func addNewFile() {
        showImagePicker(sourceType: .photoLibrary)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        isShowingImagePicker = true
    }
    
    private func saveImageToGallery(imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.alertMessage = "Image successfully saved to gallery."
                } else {
                    self.alertMessage = "Failed to save image: \(error?.localizedDescription ?? "Unknown error")"
                }
                self.showAlert = true
            }
        }
    }
}

struct FilePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerButton(
            allowEdit: true,
            selectedFileURL: .constant(URL(string: "https://pfu-expense-reciepts-test.s3.amazonaws.com/3b256ae1-2740-4e3c-8a38-b2c830de8c48/1d7a7092-dff4-4a5d-9dec-baacbbe7c729/1719194158_9FC78C92-E40D-400E-B595-AC3FC4658A3C.jpeg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIATMRWS2IXRGGLBZ72%2F20240703%2Fus-west-1%2Fs3%2Faws4_request&X-Amz-Date=20240703T044459Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=ef9ab3d9f7417c5d1007a9c65d85e70efd4ab2cb5570b9970673336bbf7dde88")),
            isShowingFilePicker: .constant(false),
            isShowingImagePicker: .constant(false),
            isShowingActionSheet: .constant(false),
            showAlert: .constant(false),
            alertMessage: .constant(""),
            isEditable: .constant(true)
        )
    }
}
