//
//  SelectTypeForm.swift
//  ExpenseManagement
//
//  Created by infra on 18/06/24.
//

import SwiftUI

struct SelectTypeForm: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var commonDataManager = CommonDataManager.instance
    
    @State var selectedType: ExpenseType?
    @State private var searchText = ""
    
    @Binding var isShowingSelf: Bool
    
    private let dao = DAO.instance
    
    let report: Report
    
    var filteredExpenseTypes: [ExpenseType] {
            if searchText.isEmpty {
                return ExpenseType.allCases
            } else {
                return ExpenseType.allCases.filter { $0.displayName.lowercased().contains(searchText.lowercased()) }
            }
        }
        
    var body: some View {
        NavigationView {
            ZStack {
                content
                    .padding()
            }
        }
    }
    
    var content: some View {
        VStack {
            reportHeader
            expenseTypeContainer
            navigateContainer
        }.padding()
    }
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(report.reportNumber)
                    .font(.system(size: 32).weight(.semibold))
                if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                    Text(DateFormatter.userFriendly.string(from: date))
                        .font(.system(size: 17).weight(.semibold))
                } else {
                    Text("Unknown Date")
                        .font(.system(size: 17).weight(.semibold))
                        .foregroundStyle(.gray)
                }
                Text(report.purpose)
                    .font(.system(size: 17).weight(.semibold))
            }
            Spacer()
        }.padding(.bottom, 3)
    }
    
    var expenseTypeContainer: some View {
        VStack(alignment: .leading) {
            Text("Expense Type")
                .font(Font.custom("Poppins", size: 18).weight(.semibold))
                .foregroundStyle(.oceanBlue)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.ourMoreLightGray)
                HStack {
                    TextField("Search", text: $searchText)
                        .foregroundStyle(.gray)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                }.padding(.horizontal)
            }.frame(height: 44)
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(Array(filteredExpenseTypes.enumerated()), id:\.element.id) { index, type in
                        Button(action: {
                            selectedType = type
                        }, label: {
                            if selectedType?.displayName == type.displayName {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.oceanBlue)
                                    HStack {
                                        Text(type.displayName)
                                            .foregroundStyle(.white)
                                            .font(Font.custom("Poppins", size: 16))
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                    }.padding()
                                }
                            } else if index % 2 == 0 {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.ourLightGray)
                                    HStack {
                                        Text(type.displayName)
                                            .foregroundStyle(.black)
                                            .font(Font.custom("Poppins", size: 16))
                                        Spacer()
                                    }.padding()
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.ourLightBlue)
                                    HStack {
                                        Text(type.displayName)
                                            .foregroundStyle(.black)
                                            .font(Font.custom("Poppins", size: 16))
                                        Spacer()
                                    }.padding()
                                }
                            }
                        }).frame(height: 44)
                    }
                }
                .padding(.top)
            }
        }
    }
    
    var navigateContainer: some View {
            ZStack {
                if let type = selectedType {
                    NavigationLink(destination: NewExpenseForm(isShowingSelf: $isShowingSelf, report: report, selectedType: selectedType ?? .airFare)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.oceanBlue)
                            Text("Next")
                                .font(Font.custom("Poppins", size: 18).weight(.semibold))
                                .foregroundStyle(.white)
                        }.frame(height: 53)
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.oceanBlue)
                        Text("Next")
                            .font(Font.custom("Poppins", size: 18).weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(height: 53)
                    .opacity(0.3)
            }
        }
    }
}

#Preview {
    SelectTypeForm(isShowingSelf: .constant(true), report: Report(
        id: "3",
        user: "something@something.com",
        reportNumber: "RPT789012",
        reportStatus: "Rejected",
        reportSubmitDate: "2023-03-10",
        integrationStatus: "Not Integrated",
        integrationDate: nil,
        reportDate: "2024-06-08",
        expenseType: "Accommodation",
        purpose: "Hotel stay during conference",
        paymentMethod: "Debit Card",
        reportAmount: "500.00",
        reportCurrency: "USD",
        createdAt: "2023-03-08T09:00:00Z",
        updatedAt: "2023-03-10T14:00:00Z"
    ))
    .environmentObject(AuthenticationManager())
}
