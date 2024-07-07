import SwiftUI
import SwiftMessages

enum MessageType {
    case success
    case error
    case info
    case warning
}

@MainActor
class SwiftMessagesManager {
    static let shared = SwiftMessagesManager()
    
    private init() {}
    
    func showMessage(title: String, message: String, type: MessageType) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureDropShadow()
        view.button?.isHidden = true
        
        switch type {
        case .success:
            view.configureTheme(.success)
        case .error:
            view.configureTheme(.error)
        case .info:
            view.configureTheme(.info)
        case .warning:
            view.configureTheme(.warning)
        }
        
        view.configureContent(title: title, body: message)
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.presentationStyle = .custom(animator: TopBottomAnimation(style: .top))
        config.duration = .seconds(seconds: 2)
        
        SwiftMessages.show(config: config, view: view)
    }
}

struct SwiftMessagesView: View {
    @EnvironmentObject var globalState: GlobalStateManager
    
    var body: some View {
        EmptyView()
            .onChange(of: globalState.showError) { newValue in
                if newValue {
                    Task {
                        await SwiftMessagesManager.shared.showMessage(title: globalState.title, message: globalState.message, type: globalState.messageType)
                    }
                    globalState.showError = false
                }
            }
    }
}

