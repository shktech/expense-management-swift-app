import SwiftUI

struct AllAmountsComponent: View {
    
    @Binding var amount: String
    @Binding var selectedCurrency: String
    @Binding var convertedAmount: Double
    @Binding var isEditable: Bool
    var targetCurrency: String
    var accessToken: String
    
    @State private var isLoading: Bool = false
    @State private var conversionRate: Double?
    
    var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundStyle(.ourLightBlue)
            VStack {
                receiptAmountContainer
                Text(conversionRateText)
                    .font(Font.custom("Nunito", size: 14).weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                convertedCurrency
            }
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.ourLightBlue)
        )
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
    
    var conversionRateText: String {
        if let rate = conversionRate {
            return "1 \(selectedCurrency) = \(rate) \(targetCurrency)"
        } else {
            return "Conversion rate not available"
        }
    }
    
    var receiptAmountContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Receipt Amount")
                .foregroundStyle(.oceanBlue)
                .font(Font.custom("Nunito", size: 16).weight(.bold))
            HStack {
                CurrencyPicker(selectedCurrency: $selectedCurrency, isEditable: $isEditable)
                .frame(width: 140)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                    TextField("", text: $amount)
                        .padding(.horizontal)
                        .keyboardType(.decimalPad)
                        .disabled(!isEditable)
                }
            }.frame(height: 45)
        }
    }
    
    var convertedCurrency: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Converted Report Amount")
                .foregroundStyle(.oceanBlue)
                .font(Font.custom("Nunito", size: 16).weight(.semibold))
            HStack {
                CurrencyPicker(selectedCurrency: .constant(targetCurrency), isEditable: .constant(false))
                .frame(width: 140)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black.opacity(0.15))
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text(Utilities.CurrencyFormatter.formatCurrency(amount: "\(convertedAmount)", currencyCode: targetCurrency))
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                    }
                }
            }.frame(height: 45)
        }.disabled(true)
    }
    
    private func convertCurrency() {
        var amountValue: Double = 0.0
        
        if let value = Double(amount) {
            amountValue = value
        } else {
            convertedAmount = 0.0
        }

        isLoading = true
        
        Utilities.CurrencyConverter.convert(amount: amountValue, from: selectedCurrency, to: targetCurrency, accessToken: accessToken) { converted, rate in
            convertedAmount = converted
            conversionRate = rate
            isLoading = false
        }
    }
}

#Preview {
    AllAmountsComponent(
        amount: .constant(""),
        selectedCurrency: .constant("USD"),
        convertedAmount: .constant(0.0),
        isEditable: .constant(false),
        targetCurrency: "USD",
        accessToken: ""
    )
}
