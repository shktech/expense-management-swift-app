import SwiftUI

struct ExpenseComponent: View {
    let expense: ExpenseItem
    
    var body: some View {
        NavigationLink(destination: ExpenseDetailView(expense: expense)) {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(expense.expenseType)
                            .font(.system(size: 17))
                            .foregroundStyle(.black)
                        if let date = DateFormatter.apiDate.date(from: expense.expenseDate) {
                            Text(DateFormatter.userFriendly.string(from: date))
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        } else {
                            Text("Unknown")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        Text(expense.justification)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                        Text("\(Utilities.CurrencyFormatter.formatCurrency(amount: expense.receiptAmount, currencyCode: expense.receiptCurrency)) \(expense.receiptCurrency)")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    HStack(spacing: 0) {
                        Text("Detail")
                            .foregroundStyle(.black.opacity(0.5))
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black.opacity(0.3))
                            .fontWeight(.semibold)
                    }
                }.padding()
            }
            .frame(height: 127)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
        }
    }
}
