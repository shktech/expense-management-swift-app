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
    @Binding var isShowingSelf: Bool
    let report: Report
        
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
            ourPfu
            line
            Spacer()
            expenseTypeContainer
            Spacer()
            navigateContainer
        }.padding()
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
        }.ignoresSafeArea()
    }

    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var expenseTypeContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Expense Type")
                .font(Font.custom("Poppins", size: 18).weight(.semibold))
                .foregroundStyle(.oceanBlue)
            Menu {
                ForEach(ExpenseType.allCases) { type in
                    Button(action: {
                        selectedType = type
                    }, label: {
                        Text(type.displayName)
                    })
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.oceanBlue, lineWidth: 1)
                    HStack {
                        Text("\(selectedType?.displayName ?? "---")")
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(selectedType?.displayName == nil ? .gray : .oceanBlue)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.oceanBlue)
                            .fontWeight(.semibold)
                    }.padding(.horizontal)
                }
            }.frame(height: 41)
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
        user: (dao.user?.first_name ?? "") + (dao.user?.last_name ?? ""),
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
