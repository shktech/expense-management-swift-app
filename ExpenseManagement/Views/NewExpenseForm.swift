//
//  NewExpenseForm.swift
//  ExpenseManagement
//
//  Created by infra on 02/06/24.
//

import SwiftUI

struct NewExpenseForm: View {
    
    @Binding var isShowingSelf: Bool
    
    let report: Reports
    
    let types: [Types] = [
        .Food,
        .Hotel,
        .Traveling
    ]
    
    let countries: [String] = [
        "USD",
        "CAD"
    ]

    
    @State var selectedType: Types?
    
    @State var selectedCity: String = "---"
    
    @State var date: Date = Date()
    
    @State var selectedCurrency: String = "USD"
    
    @State var amount: String = ""
    
    @State var justification: String = ""
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            content
                .padding()
        }
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
        }.ignoresSafeArea()
    }
    
    var content: some View {
        ScrollView {
            VStack {
                ourPfu
                line
                reportHeader
                expenseTypeContainer
                cityContainer
                dateField
                recieptAmountContainer
                if selectedCurrency == "USD" {
                    VStack {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundStyle(.gray)
                        convertedCurrency
                    }.padding(.top)
                }
                justificationContainer
                Spacer()
                saveButton
                    .padding(.top)
            }.padding()
        }
    }
    
    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("\(report.id)")
                    .font(.system(size: 32).weight(.semibold))
                Text(report.createdAt.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 17).weight(.semibold))
                Text(report.purpose)
                    .font(.system(size: 17).weight(.semibold))
            }
            Spacer()
        }
    }
    
    var expenseTypeContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Expense Type")
                .foregroundStyle(.gray)
                Menu {
                    ForEach(types.indices) {index in
                        Button(action: {
                            selectedType = types[index]
                        }, label: {
                            Text("\(types[index].displayName)")
                        })
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                        HStack {
                            Text("\(selectedType != nil ? selectedType!.displayName : "---")")
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.gray)
                                .fontWeight(.semibold)
                        }.padding(.horizontal)
                    }
                }.frame(height: 41)

        }.padding(.top)
    }
    
    var cityContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("City")
                .foregroundStyle(.gray)
                Menu {
                    ForEach(dao.cities ?? [], id:\.self.id) {city in
                        Button(action: {
                            selectedCity = city.value
                        }, label: {
                            Text(city.value)
                        })
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                        HStack {
                            Text(selectedCity)
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.gray)
                                .fontWeight(.semibold)
                        }.padding(.horizontal)
                    }
                }.frame(height: 41)

        }.padding(.top)
    }
    
    var dateField: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Date")
                .foregroundStyle(.gray)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(height: 41)
                HStack {
                    Text("\(date.formatted(date: .numeric, time: .omitted))")
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.gray)
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
    
    var recieptAmountContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Reciept Amount")
                .foregroundStyle(.gray)
            HStack {
                Menu {
                    ForEach(countries, id:\.self) { currency in
                        Button(action: {
                            selectedCurrency = currency
                        }, label: {
                            Text(currency)
                        })
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                        HStack {
                            Image(selectedCurrency)
                            Text(selectedCurrency)
                                .foregroundStyle(.black)
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.gray)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .frame(width: 100)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    TextField("", text: $amount)
                        .padding(.horizontal)
                }
            }.frame(height: 41)
        }
        .padding(.top)
    }
    
    var convertedCurrency: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Converted Reporting Amount")
                .foregroundStyle(.gray)
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    HStack {
                        Image("CAD")
                        Text("CAD")
                            .foregroundStyle(.black)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }
                }
                .frame(width: 100)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                    Text("\(((Double(amount) ?? 0) * 1.37).formatted())")
                }
            }.frame(height: 41)
        }
        .padding(.top)
    }
    
    var justificationContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Justification")
                .foregroundStyle(.gray)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                        TextField("Justify your expense here", text: $justification)
                        .padding(.horizontal)
                }.frame(height: 41)

        }.padding(.top)
    }
    
    var saveButton: some View {
        Button(action: {
            // save new expense
            isShowingSelf.toggle()
        }, label: {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.blue)
                    Text("Save")
                        .foregroundStyle(.white)
                        .font(.system(size: 17).weight(.semibold))
                }
            }
        }).frame(height: 41)
    }
}

//#Preview {
//    NewExpenseForm(report: Reports(name: "Exp 1020", date: Date(), purpose: "New Conference", status: false, expenseItems: [
//        ExpenseItem(type: .Food, date: Date(), value: 120, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "", expirationDate: Date()), currency: "USD"),ExpenseItem(type: .Food, date: Date(), value: 120, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "", expirationDate: Date()), currency: "USD")
//    ]))
//}
