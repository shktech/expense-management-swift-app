//
//  NewReportView.swift
//  ExpenseManagement
//
//  Created by infra on 02/06/24.
//

import SwiftUI

struct NewReportView: View {
    
    @Binding var isSHowing: Bool
    
    let user: User?
    
    @State var newReportName: String = "New Report"
    @FocusState private var isTextFieldFocused: Bool
    
    @State var date: Date = Date()
    
    @State var purposeField: String = ""
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
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            ZStack {
                ourPfu
                content
            }.padding()
        }
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
            Spacer()
        }.ignoresSafeArea()
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            newReportNameField
            dateField
            purposeFieldContainer
            preferredPaymentMethodContainer
            currencyField
            Spacer()
            addButton
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
    
    var newReportNameField: some View {
        HStack {
            Text(newReportName)
                .font(.system(size: 32).weight(.semibold))
            Spacer()
        }.padding(.top)
    }
    
    var dateField: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Date")
                .foregroundStyle(.gray)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(height: 41)
                HStack {
                    Text("\(date.formatted(date: .numeric, time: .omitted))")
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.title3)
                        .overlay{ //MARK: Place the DatePicker in the overlay extension
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: [.date]
                            )
                            .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                        }
                }.padding()
            }
        }.padding(.top)
    }
    
    var purposeFieldContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Purpose")
                .foregroundStyle(.gray)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(height: 41)
                TextField("ex: New Conference", text: $purposeField)
                    .padding()
            }
        }.padding(.top)
    }
    
    var preferredPaymentMethodContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Preferred Payment Method")
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
                        .stroke(Color.gray, lineWidth: 2)
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
        }.padding(.top)
    }
    
    var currencyField: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Currency")
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
    
    var addButton: some View {
        Button(action: {
            // add new reports
            isSHowing.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.blue)
                Text("Add")
                    .foregroundStyle(.white)
                    .font(.system(size: 17).weight(.semibold))
                    
            }
        }).frame(height: 41)
    }
}

#Preview {
    NewReportView(isSHowing: .constant(false), user: User(name: "John Doe", username: "johnDoe", email: "john.doe@example.com", password: "password123", department: "IT Department", reports: [], paymentMethods: [
        CreditCard(cardNumber: "1234123412341234", expirationDate: Date().addingTimeInterval(-3600)),
        CreditCard(cardNumber: "1234123412341234", expirationDate: Date())
    ]))
}
