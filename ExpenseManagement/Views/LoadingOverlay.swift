import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5) // Semi-transparent grey background
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2)
        }
    }
}

struct LoadingOverlayModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)

            if isLoading {
                LoadingOverlayView()
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}
