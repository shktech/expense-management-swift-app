import SwiftUI

struct CurrencyPicker: View {
    @Binding var selectedCurrency: String
    
    let currencies = [
        ("$", "USD", "🇺🇸"),
        ("$", "CAD", "🇨🇦"),
        ("¥", "JPY", "🇯🇵")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Default Currency")
                .font(.system(size: 13).weight(.semibold))
                .foregroundStyle(.black)
            Menu {
                ForEach(currencies, id: \.1) { currency in
                    Button(action: {
                        selectedCurrency = currency.1
                    }) {
                        Text("\(currency.2) \(currency.1) \(currency.0)")
                    }
                }
            } label: {
                HStack {
                    if let selectedCurrencyDetails = currencies.first(where: { $0.1 == selectedCurrency }) {
                        Text("\(selectedCurrencyDetails.2) \(selectedCurrencyDetails.1) \(selectedCurrencyDetails.0)")
                            .foregroundColor(.black)
                    } else {
                        Text("Select Currency")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .frame(height: 50)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    CurrencyPicker(selectedCurrency: .constant("USD"))
}
