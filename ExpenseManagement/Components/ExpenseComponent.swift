import SwiftUI

struct ExpenseComponent: View {
    let expense: ExpenseItem
    let report: Report
    
    var body: some View {
        NavigationLink(destination: EditExpenseForm(allowEdit: report.reportStatus == "Open", report: report, expenseItem: expense)) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.ourMoreLightGray)
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        if let date = DateFormatter.apiDate.date(from: expense.expenseDate) {
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
                        Text(expense.expenseType.rawValue)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                        Text(expense.justification)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                        Text("\(Utilities.CurrencyFormatter.formatCurrency(amount: expense.receiptAmount, currencyCode: expense.receiptCurrency))")
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundStyle(.black)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 7)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        }.frame(height: 100)
    }
}

#Preview {
    ExpenseComponent(expense: ExpenseItem(
        id: "1",
        airline: "Example Airline",
        rentalAgency: "Example Rental Agency",
        carType: "SUV",
        mealCategory: "Lunch",
        relationshipToPAI: "Business",
        city: "Example City",
        hotelDailyBaseRate: nil,
        mileageRate: nil,
        presignedURL: "https://example.com/receipt.pdf",
        filename: "receipt.pdf",
        expenseType: ExpenseType.airlineFees,
        expenseDate: "2024-06-15",
        receiptAmount: "150.00",
        receiptCurrency: "USD",
        justification: "Client meeting",
        note: "No additional notes",
        s3Path: "s3://bucket/path/to/receipt.pdf",
        originDestination: "Example Origin to Example Destination",
        employeeNames: "John Doe, Jane Doe",
        totalEmployees: 2,
        companyCustomerName: "Example Company",
        businessTopic: "Project discussion",
        totalAttendees: 4,
        nameOfEstablishment: "Example Hotel",
        hotelName: "Example Hotel",
        carrier: "Example Carrier",
        distance: "100 miles",
        createdAt: "2024-06-14T10:00:00Z",
        updatedAt: "2024-06-15T10:00:00Z",
        report: 123
    ), report: Report(
        id: "3",
        user: "some@gmail.com",
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
    )
)
}
