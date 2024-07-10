import SwiftUI
import FormValidator

struct TextInputView: View {
    let title: String
    @Binding var text: String
    @Binding var isEditable: Bool
    let validation: ValidationContainer?
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.ourLightGray)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.oceanBlue, lineWidth: 1.5)
                VStack {
                    HStack {
                        TextField(placeholder, text: $text)
                            .font(Font.custom("Nunito", size: 16))
                            .foregroundStyle(.oceanBlue)
                            .disabled(!isEditable)
                    }.padding(.horizontal)
                }
                if !isEditable {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black)
                        .opacity(0.15)
                }
            }
            .frame(height: 45)
            .validation(validation) { message in
                Text(message)
                    .foregroundColor(.red)
                    .opacity(0.7)
                    .font(.system(size: 14))
            }
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(title: "Hotel Name", text: .constant(""), isEditable: .constant(true), validation: nil, placeholder: "---")
    }
}
