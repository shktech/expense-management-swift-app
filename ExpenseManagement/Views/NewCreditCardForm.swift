import SwiftUI

class CreditCardViewModel: ObservableObject {
    @Published var creditCardNumberField: String
    @Published var expDate: String
    @Published var cardType: String = ""
    @Published var cardIcon: String = "creditcard"
    @Published var readonly: Bool
    
    init(creditCardNumber: String = "", expDate: String = "", readonly: Bool = false) {
        self.creditCardNumberField = creditCardNumber
        self.expDate = expDate
        self.readonly = readonly
        formatCreditCardNumber()
        determineCardType()
    }

    func formatCreditCardNumber() {
        let digits = creditCardNumberField.filter { $0.isNumber }
        let formattedNumber = digits.chunked(by: 4).map { String($0) }.joined(separator: " ")
        if formattedNumber != creditCardNumberField {
            creditCardNumberField = formattedNumber
        }
    }

    func determineCardType() {
        let digits = creditCardNumberField.filter { $0.isNumber }
        if digits.hasPrefix("4") {
            cardType = "Visa"
            cardIcon = "visa"
        } else if digits.hasPrefix("5") {
            cardType = "MasterCard"
            cardIcon = "mastercard"
        } else if digits.hasPrefix("3") && digits.count > 1 && (digits[digits.index(digits.startIndex, offsetBy: 1)] == "4" || digits[digits.index(digits.startIndex, offsetBy: 1)] == "7") {
            cardType = "American Express"
            cardIcon = "amex"
        } else if digits.hasPrefix("6") {
            cardType = "Discover"
            cardIcon = "discover"
        } else {
            cardType = "Unknown"
            cardIcon = "creditcard"
        }
    }
}

struct NewCreditCardForm: View {
    @StateObject var viewModel: CreditCardViewModel
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var globalState: GlobalStateManager
    
    init(viewModel: CreditCardViewModel = CreditCardViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack {
                content
            }.padding()
        }
    }

    var content: some View {
        VStack {
            creditCardNumberContainer
            expDateContainer
            Spacer()
            if !viewModel.readonly {
                saveButton
            }
        }.padding()
    }

    var creditCardNumberContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Card Number")
            HStack {
                if viewModel.cardIcon == "creditcard" {
                    Image(systemName: viewModel.cardIcon)
                        .foregroundColor(.gray)
                } else {
                    Image(viewModel.cardIcon)
                        .resizable()
                        .frame(width: 30, height: 24)
                }
                if viewModel.readonly {
                    Text(viewModel.creditCardNumberField)
                        .frame(height: 40)
                } else {
                    TextField("Credit card number", text: $viewModel.creditCardNumberField)
                        .keyboardType(.numberPad)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .frame(height: 40)
                }
            }.padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
            )
        }.padding(.vertical)
    }

    var expDateContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Expiration Date")
            if viewModel.readonly {
                Text(viewModel.expDate)
                    .frame(height: 40)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            } else {
                TextField("MM/YY", text: $viewModel.expDate)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .frame(height: 40)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
        }.padding(.top)
    }

    var saveButton: some View {
        Button(action: {
            addCreditCard()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.oceanBlue)
                Text("Save")
                    .foregroundStyle(.white)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
            }
        }).frame(height: 50)
    }

    func addCreditCard() {
        let cardNumber = viewModel.creditCardNumberField.replacingOccurrences(of: " ", with: "")
        let expirationDate = formatExpirationDate(viewModel.expDate)
        
        authManager.createCreditCard(cardNumber: cardNumber, expirationDate: expirationDate) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    globalState.showMessage(title: "Success", message: "Successfully added credit card information", type: .success)
                    self.presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                globalState.showMessage(title: "Error", message: "Failed to add credit card information: \(error.localizedDescription)", type: .error)
            }
        }
    }
    
    func formatExpirationDate(_ expDate: String) -> String {
        let components = expDate.split(separator: "/")
        guard components.count == 2,
              let month = components.first,
              let year = components.last else {
            return expDate
        }
        return "20\(year)-\(month)-01"
    }
}

#Preview {
    NewCreditCardForm()
        .environmentObject(AuthenticationManager())
        .environmentObject(GlobalStateManager())
}
