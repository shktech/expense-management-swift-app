//
//  ManagePaymentView.swift
//  ExpenseManagement
//
//  Created by infra on 01/06/24.
//

import SwiftUI

struct ManagePaymentView: View {
    
    let user: User?
    let allCurrency: [String] = [
        "USD", // Dólar Americano
        "BRL", // Real Brasileiro
        "EUR", // Euro
        "GBP", // Libra Esterlina
        "JPY", // Iene Japonês
        "CNY", // Yuan Chinês
        "AUD", // Dólar Australiano
        "CAD", // Dólar Canadense
        "CHF", // Franco Suíço
        "INR", // Rúpia Indiana
        "RUB", // Rublo Russo
        "ZAR", // Rand Sul-Africano
        "HKD", // Dólar de Hong Kong
        "SGD", // Dólar de Singapura
        "KRW", // Won Sul-Coreano
        "MXN", // Peso Mexicano
        "TRY", // Lira Turca
        "SAR", // Rial Saudita
        "AED", // Dirham dos Emirados
        "NOK", // Coroa Norueguesa
        "SEK", // Coroa Sueca
        "DKK", // Coroa Dinamarquesa
        "PLN", // Zloty Polonês
        "NZD", // Dólar Neozelandês
        "THB"  // Baht Tailandês
    ]
    
    @Binding var isShowing: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                ourPfu
                ZStack {
                    content
                }.padding()
            }
        }
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
                    .padding(.top, 40)
                    .padding(.trailing, 20)
            }
            Spacer()
        }.ignoresSafeArea()
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            defaultPaymentMethod
            creditCards
            defaultCurrency
            Spacer()
            saveButton
            cancelButton
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(user?.name ?? "")
                    .font(.system(size: 17).weight(.semibold))
                Text(user?.department ?? "")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            .padding(.bottom)
            Spacer()
        }
    }
    
    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var defaultPaymentMethod: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Default Payment Method")
                .foregroundStyle(.gray)
            Menu {
                Button(action: {
                    
                }, label: {
                    Text("Card ending in 1111")
                })
                Button(action: {
                    
                }, label: {
                    Text("Card ending in 2222")
                })
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.5), lineWidth: 2)
                        .frame(height: 41)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                    HStack {
                        if user?.defaultPaymentMethod != nil {
                            Text("Card ending in xxx")
                                .foregroundStyle(Color.gray)
                        } else {
                            Text("---")
                                .foregroundStyle(Color.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray)
                    }.padding()
                }
            }
        }.padding(.top, 7)
    }
    
    var creditCards: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Credit Cards")
                .foregroundStyle(.gray)
            if user?.defaultPaymentMethod != nil {
                VStack(spacing: 0) {
                    ForEach(user?.paymentMethods ?? []) { card in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.5), lineWidth: 2)
                                .frame(height: 41)
                                .foregroundStyle(Color(uiColor: .systemGray6))
                            HStack() {
                                Image("Visa")
                                Text("XXX.XXX.XXX.\(getLastFourCharacters(from: card.cardNumber))")
                                    .foregroundStyle(Color.black.opacity(0.3))
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                })
                            }.padding()
                        }
                    }
                }
            } else {
                NavigationLink(destination: NewCreditCardForm(user: user)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 41)
                            .foregroundStyle(.green)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.5), lineWidth: 2)
                            .frame(height: 41)
                            .foregroundStyle(Color(uiColor: .systemGray6))
                        HStack() {
                            Text("+ Add new Credit Card")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
    
    var defaultCurrency: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Default Currency")
                .foregroundStyle(.gray)
            Menu {
                ForEach(allCurrency, id: \.self) { currency in
                    Button(action: {
                        
                    }, label: {
                        Text(currency)
                    })
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.5), lineWidth: 2)
                        .frame(height: 41)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                    HStack {
                        if user?.defaultPaymentMethod != nil {
                            Text("Card ending in xxx")
                                .foregroundStyle(Color.gray)
                        } else {
                            Text("USD")
                                .foregroundStyle(Color.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.gray)
                    }.padding()
                }
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.blue)
                Text("Save")
                    .foregroundStyle(.white)
                    .font(.system(size: 17).weight(.semibold))
            }
        }).frame(height: 45)
    }
    
    var cancelButton: some View {
        Button(action: {
            isShowing.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.gray)
                Text("Cancel")
                    .foregroundStyle(.white)
                    .font(.system(size: 17).weight(.semibold))
            }
        }).frame(height: 45)
    }
    
    func getLastFourCharacters(from string: String) -> String {
            let length = string.count
            if length < 4 {
                return string
            }
            let startIndex = string.index(string.endIndex, offsetBy: -4)
            let lastFour = string[startIndex...]
            return String(lastFour)
        }
}

#Preview {
    ManagePaymentView(user: User(name: "John Doe", username: "johnDoe", email: "john.doe@example.com", password: "password123", department: "IT Department", reports: [], paymentMethods: [
        CreditCard(cardNumber: "1234123412341234", expirationDate: Date().addingTimeInterval(-3600)),
        CreditCard(cardNumber: "1234123412341234", expirationDate: Date())
    ]), isShowing: .constant(false))
}
