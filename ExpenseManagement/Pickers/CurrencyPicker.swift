import SwiftUI

struct CurrencyPicker: View {
    @Binding var selectedCurrency: String
    @Binding var isEditable: Bool
    @State private var showCurrencyPicker = false
    var title: String?

    let currencies = [
        ("$", "USD", "🇺🇸"),
        ("$", "CAD", "🇨🇦"),
        ("¥", "JPY", "🇯🇵"),
        ("€", "EUR", "🇪🇺"),
        ("£", "GBP", "🇬🇧"),
        ("₹", "INR", "🇮🇳")
    ]
    
    @Binding var isFocused: Bool

    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if (title != nil) {
                Text(title ?? "Default Concurrency")
                    .font(Font.custom("Nunito", size: 16).weight(.bold))
                    .foregroundStyle(.oceanBlue)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isEditable ? .ourLightGray : .black.opacity(0.15))
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.oceanBlue, lineWidth: isFocused ? 1 : 0)
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
                        .foregroundStyle(.oceanBlue)
                        .fontWeight(.semibold)
                        .opacity(isEditable ? 1:0)
                }
                .padding(.horizontal)
            }
            .frame(height: 45)
            .onTapGesture {
                if isEditable {
                    showCurrencyPicker.toggle()
                }
            }
        }
        .focused($fieldIsFocused)
        .onChange(of: fieldIsFocused) { newValue in
            isFocused = newValue
        }
        .sheet(isPresented: $showCurrencyPicker) {
            VStack(spacing: 15) {
                Text("Select Currency")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.oceanBlue)
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(currencies, id: \.1) { currency in
                            Button {
                                selectedCurrency = currency.1
                                showCurrencyPicker = false
                            } label: {
                                ZStack {
                                    if selectedCurrency == currency.1 {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.oceanBlue)
                                        HStack {
                                            Text("\(currency.2) \(currency.1) \(currency.0)")
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.white)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }.padding()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(.gray.opacity(0.2))
                                        HStack {
                                            Text("\(currency.2) \(currency.1) \(currency.0)")
                                                .font(Font.custom("Nunito", size: 16))
                                                .foregroundStyle(.black)
                                            Spacer()
                                        }.padding()
                                    }
                                }
                            }
                            .frame(height: 44)
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
            }
            .padding()
            .presentationDetents([.fraction(0.5)])
        }
    }
}

struct CurrencyPicker_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPicker(selectedCurrency: .constant("USD"), isEditable: .constant(true), title: "Passed in title", isFocused: .constant(true))
    }
}
