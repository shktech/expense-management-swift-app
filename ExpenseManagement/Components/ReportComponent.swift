import SwiftUI

struct ReportComponent: View {
    
    @Binding var report: Report
    
    var body: some View {
        NavigationLink(destination: ReportsDetailView(report: $report)) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.ourMoreLightGray)
                HStack {
                    VStack(alignment: .leading) {
                        Text(report.reportNumber)
                            .font(.system(size: 17).weight(.semibold))
                            .foregroundStyle(.black)
                        if let date = DateFormatter.apiDate.date(from: report.reportDate) {
                            Text(DateFormatter.userFriendly.string(from: date))
                                .font(Font.custom("Poppins", size: 14))
                                .foregroundColor(.gray)
                        } else {
                            Text("Unknown")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        ReportStatusView(reportStatus: report.reportStatus)
                    }.frame(width: 100)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.oceanBlue)
                        .frame(width: 1.5)
                    HStack{
                        VStack(alignment: .leading) {
                            Text(report.purpose)
                                .font(Font.custom("Poppins", size: 14).weight(.semibold))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(.oceanBlue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(Utilities.CurrencyFormatter.formatCurrency(amount: report.reportAmount, currencyCode: report.reportCurrency)) \(report.reportCurrency)")
                                .font(Font.custom("Poppins", size: 14).weight(.semibold))
                                .foregroundStyle(.black)
                            VStack(alignment: .leading) {
                                if let submitDate = DateFormatter.apiDate.date(from: report.reportSubmitDate ?? "") {
                                    Text("Submission Date: \(DateFormatter.userFriendly.string(from: submitDate))")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray)
                                } else {
                                    Text("Submission Date: N/A")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray)
                                }
                                Text("Approval Date: N/A").font(.system(size: 12)).foregroundStyle(.gray)
                            }.padding(.top, 1)
                        }
//                        Image(systemName: "chevron.right")
//                            .font(.system(size: 20).weight(.semibold))
//                            .foregroundStyle(.oceanBlue)
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 7)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        }.frame(height: 100)
            .onAppear(perform: log)
    }
    
    private func log() {
        print(report)
    }
}

#Preview {
    ReportComponent(report: .constant(
        Report(
            id: "1",
            user: "something@gmail.com",
            reportNumber: "RPT123456",
            reportStatus: "Open",
            reportSubmitDate: "2024-06-27",
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
