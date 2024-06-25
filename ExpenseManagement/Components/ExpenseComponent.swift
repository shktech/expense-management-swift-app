import SwiftUI

struct ExpenseComponent: View {
    let expense: ExpenseItem
    
    var body: some View {
        NavigationLink(destination: ExpenseDetailView(expense: expense)) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.ourLightGray)
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.oceanBlue, lineWidth: 1.5)
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
                        Text(expense.expenseType)
                            .font(Font.custom("Poppins", size: 16).weight(.semibold))
                            .foregroundStyle(.oceanBlue)
                        Text(expense.justification)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundStyle(.black)
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
                }.padding()
            }
        }
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
        expenseType: "Travel",
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
    ))
}
