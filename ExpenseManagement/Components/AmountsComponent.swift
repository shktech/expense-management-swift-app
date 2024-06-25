import SwiftUI

struct AllAmountsComponent: View {
    
    @Binding var amount: String
    @Binding var selectedCurrency: String
    @Binding var convertedAmount: Double
    var targetCurrency: String
    var accessToken: String
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.ourLightBlue)
            RoundedRectangle(cornerRadius: 10)
                .stroke(.oceanBlue, lineWidth: 1)
            VStack {
                receiptAmountContainer
                convertedCurrency
            }.padding()
        }
        .onAppear {
            convertCurrency()
        }
        .onChange(of: amount) { _ in
            convertCurrency()
        }
        .onChange(of: selectedCurrency) { _ in
            convertCurrency()
        }
    }
    
    var receiptAmountContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Receipt Amount")
                .foregroundStyle(.oceanBlue)
                .font(Font.custom("Poppins", size: 16).weight(.semibold))
            HStack {
                Menu {
                    ForEach(currencies, id: \.code) { currency in
                        Button(action: {
                            selectedCurrency = currency.code
                        }, label: {
                            Text("\(currency.flag) \(currency.code)")
                        })
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.ourLightGray)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.oceanBlue, lineWidth: 1)
                        HStack {
                            Text(currencyFlag(for: selectedCurrency))
                            Text(selectedCurrency)
                                .foregroundStyle(.oceanBlue)
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.oceanBlue)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .frame(width: 100)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.oceanBlue, lineWidth: 1)
                    TextField("", text: $amount)
                        .padding(.horizontal)
                        .keyboardType(.decimalPad) // Ensure keyboard is suitable for currency input
                }
            }.frame(height: 41)
        }
    }
    
    var convertedCurrency: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Converted Report Amount")
                .foregroundStyle(.oceanBlue)
                .font(Font.custom("Poppins", size: 16).weight(.semibold))
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.oceanBlue, lineWidth: 1)
                    HStack {
                        Text(currencyFlag(for: targetCurrency))
                        Text(targetCurrency)
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                    }
                }
                .frame(width: 100)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.ourLightGray)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.oceanBlue, lineWidth: 1)
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text(Utilities.CurrencyFormatter.formatCurrency(amount: "\(convertedAmount)", currencyCode: targetCurrency))
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                    }
                }
            }.frame(height: 41)
        }.disabled(true)
    }
    
    private func convertCurrency() {
        guard let amountValue = Double(amount) else {
            convertedAmount = 0.0
            return
        }
        
        isLoading = true
        
        Utilities.CurrencyConverter.convert(amount: amountValue, from: selectedCurrency, to: targetCurrency, accessToken: accessToken) { converted in
            convertedAmount = converted
            isLoading = false
        }
    }
    
    private var currencies: [(code: String, flag: String)] {
        [
            ("USD", "🇺🇸"),
            ("CAD", "🇨🇦"),
            ("JPY", "🇯🇵")
        ]
    }
    
    private func currencyFlag(for currencyCode: String) -> String {
        return currencies.first { $0.code == currencyCode }?.flag ?? "🏳️"
    }
}

#Preview {
    AllAmountsComponent(
        amount: .constant("1200"),
        selectedCurrency: .constant("USD"),
        convertedAmount: .constant(0.0),
        targetCurrency: "USD",
        accessToken: ""
    )
}
