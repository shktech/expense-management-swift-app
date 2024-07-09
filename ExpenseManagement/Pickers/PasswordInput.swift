import SwiftUI
import FormValidator

struct PasswordInputView: View {
    let title: String
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
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
                HStack {
                    if isPasswordVisible {
                        TextField(placeholder, text: $password)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .font(Font.custom("Nunito", size: 16))
                            .foregroundStyle(.oceanBlue)
                    } else {
                        SecureField(placeholder, text: $password)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .font(Font.custom("Nunito", size: 16))
                            .foregroundStyle(.oceanBlue)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }.padding(.horizontal)
                if !isEditable {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black)
                        .opacity(0.15)
                }
            }
            .frame(height: 45)
            .validation(validation)
        }
    }
}

