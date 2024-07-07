import SwiftUI

struct TextInputView: View {
    let title: String
    @Binding var text: String
    @Binding var isEditable: Bool
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.ourLightGray)
                HStack {
                    TextField(placeholder, text: $text)
                        .font(Font.custom("Nunito", size: 16))
                        .foregroundStyle(.oceanBlue)
                        .disabled(!isEditable)
                }.padding(.horizontal)
                if !isEditable {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black)
                        .opacity(0.15)
                }
            }
            .frame(height: 41)
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(title: "Hotel Name", text: .constant(""), isEditable: .constant(true), placeholder: "---")
    }
}
