import SwiftUI

struct ReportComponent: View {
    
    @Binding var report: Report
    
    var body: some View {
        NavigationLink(destination: ReportsDetailView(report: $report)) {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                HStack {
                    VStack(alignment: .leading) {
                        Text(report.reportNumber)
                            .font(.system(size: 17).weight(.semibold))
                            .foregroundStyle(.black)
                        if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                            Text(DateFormatter.userFriendly.string(from: date))
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        } else {
                            Text("Unknown")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        Text(report.purpose)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                        Text("\(Utilities.CurrencyFormatter.formatCurrency(amount: report.reportAmount, currencyCode: report.reportCurrency)) \(report.reportCurrency)")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                        Text(report.reportStatus)
                            .foregroundStyle(report.reportStatus == "Submitted" ? .green : .red)
                            .font(.system(size: 15).weight(.semibold))
                    }
                    Spacer()
                    HStack(spacing: 0) {
                        Text("Detail")
                            .foregroundStyle(.black.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black.opacity(0.3))
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 7)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
        }
    }
}

#Preview {
    ReportComponent(report: .constant(
        Report(
            id: "1",
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
    ))
}
