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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Phone Number")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            VStack(spacing: 3) {
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
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 50)
                    }
                    
                    Divider()
                        .frame(width: 1, height: 30)
                        .background(Color.gray)
                    
                    TextField("Enter your phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 10)
                        .frame(height: 50)
                        .onChange(of: phoneNumber) { newValue in
                            parsePhoneNumber()
                        }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                if let validationMessage = validationMessage {
                    Text(validationMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 13).weight(.semibold))
                }
            }
        }
    }
    
    private func parsePhoneNumber() {
        do {
            let fullNumber = "\(countryCode)\(phoneNumber)"
            let parsedPhoneNumber = try phoneNumberKit.parse(fullNumber)
            fullPhoneNumber = fullNumber
            print(fullNumber)
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

struct PhoneNumberInputView_Previews: PreviewProvider {
    @State static var fullPhoneNumber: String = ""

    static var previews: some View {
        PhoneNumberInputView(fullPhoneNumber: $fullPhoneNumber)
    }
}
