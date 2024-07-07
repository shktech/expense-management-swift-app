import SwiftUI

class GlobalStateManager: ObservableObject {
    @Published var showError: Bool = false
    @Published var message: String = ""
    @Published var title: String = ""
    @Published var messageType: MessageType = .info
    
    func showMessage(title: String, message: String, type: MessageType) {
        self.title = title
        self.message = message
        self.messageType = type
        self.showError = true
    }
}
