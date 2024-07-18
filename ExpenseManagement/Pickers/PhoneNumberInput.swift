import SwiftUI
import PhoneNumberKit

struct PhoneNumberInputView: View {
    @Binding var fullPhoneNumber: String
    @State private var phoneNumber: String = ""
    @State private var countryCode: String = "+1"
    @State private var countryFlag: String = "🇺🇸"
    @State private var showCountryPicker: Bool = false
    @State private var parsedPhoneNumber: PhoneNumber?
    @State private var validationMessage: String?
    private let phoneNumberKit = PhoneNumberKit()
    
    @Binding var isFocused: Bool // Binding para o estado de foco

    @FocusState private var fieldIsFocused: Bool // FocusState para o TextField
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Phone Number")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                HStack(spacing: 0) {
                    Menu {
                        ForEach(countryCodes, id: \.0) { country in
                            Button(action: {
                                countryCode = country.1
                                countryFlag = country.2
                            }) {
                                Text("\(country.2) \(country.0) \(country.1)")
                            }
                        }
                    } label: {
                        HStack {
                            Text(countryFlag)
                            Text(countryCode)
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.oceanBlue)
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 45)
                    }
                    
                    Divider()
                        .frame(width: 1, height: 30)
                        .background(Color.gray)
                    
                    TextField("Enter your phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 10)
                        .frame(height: 45)
                        .focused($fieldIsFocused) // Vinculando o FocusState ao TextField
                        .onChange(of: phoneNumber) { newValue in
                            parsePhoneNumber()
                        }
                }
                .onChange(of: fieldIsFocused) { newValue in
                    isFocused = newValue // Atualizando o estado de foco externo
                }
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: isFocused ? 1 : 0)
                }
                .frame(height: 45)
            }
            if let validationMessage = validationMessage {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 13).weight(.semibold))
            }
        }
        .animation(Animation.easeInOut(duration: 0.1), value: fieldIsFocused)
    }
    
    private func parsePhoneNumber() {
        do {
            let fullNumber = "\(countryCode)\(phoneNumber)"
            let parsedPhoneNumber = try phoneNumberKit.parse(fullNumber)
            fullPhoneNumber = fullNumber
            validationMessage = nil
        } catch {
            validationMessage = "Invalid phone number"
        }
    }
    
    private let countryCodes = [
        ("United States", "+1", "🇺🇸"),
        ("Canada", "+1", "🇨🇦"),
        ("Japan", "+81", "🇯🇵")
    ]
}

//struct PhoneNumberInputView_Previews: PreviewProvider {
//    @State static var fullPhoneNumber: String = ""
//
//    static var previews: some View {
//        PhoneNumberInputView(fullPhoneNumber: $fullPhoneNumber)
//    }
//}
