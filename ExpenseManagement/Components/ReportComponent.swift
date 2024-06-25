//
//  ReportComponent.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI

struct ReportComponent: View {
    
    let report: Report
    
    var body: some View {
        NavigationLink(destination: ReportsDetailView(report: report)) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.ourLightGray)
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.oceanBlue, lineWidth: 1)
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                            Text(DateFormatter.userFriendly.string(from: date))
                                .font(Font.custom("Poppins", size: 14))
                                .foregroundColor(.gray)
                        } else {
                            Text("Unknown")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }.frame(width: 100)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.oceanBlue)
                        .frame(width: 1.5)
                    VStack(alignment: .leading) {
                        Text(report.id)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                        Text(report.purpose)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                        Text("\(Utilities.CurrencyFormatter.formatCurrency(amount: report.reportAmount, currencyCode: report.reportCurrency))")
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundStyle(.black)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    ReportComponent(report: 
                        Report(
                            id: "1",
                            user: (dao.user?.first_name ?? "") + (dao.user?.last_name ?? ""),
                            reportNumber: "RPT123456",
                            reportStatus: "Pending",
                            reportSubmitDate: "2023-01-15",
                            integrationStatus: "Not Integrated",
                            integrationDate: nil,
                            reportDate: "2024-06-08",
                            expenseType: "Travel",
                            purpose: "Business trip to NYC",
                            paymentMethod: "Credit Card",
                            reportAmount: "1200.00",
                            reportCurrency: "USD",
                            createdAt: "2023-01-10T10:00:00Z",
                            updatedAt: "2023-01-15T12:00:00Z"
                        )
    )
}
