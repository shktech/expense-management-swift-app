import SwiftUI

struct ContentUnavailableView: View {
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.append")
                .font(.system(size: 30))
                .foregroundStyle(Color.secondary)
            Text(title)
                .font(.title3)
                .foregroundStyle(Color.secondary)
            Text(description)
                .font(.body)
                .foregroundStyle(Color.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ContentUnavailableView(title: "No items", description: "Tap the “+“ button and start writing")
}
