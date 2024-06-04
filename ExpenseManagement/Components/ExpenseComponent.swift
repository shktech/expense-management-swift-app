//
//  ExpenseComponent.swift
//  ExpenseManagement
//
//  Created by infra on 02/06/24.
//

import SwiftUI

struct ExpenseComponent: View {
    
    let expense: ExpenseItem
    
    let report: Reports
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(expense.expenseType)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Text(expense.createdAt.formatted(date: .numeric, time: .omitted))
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    Text(expense.justification)
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    Text("\(expense.receiptAmount)")
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

//#Preview {
//    ExpenseComponent(expense: ExpenseItem(type: .Hotel, date: Date(), value: 120.91, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "1234.1234.1234.1234", expirationDate: Date()), currency: "USD"), report: Reports(name: "Exp 1020", date: Date(), purpose: "New Conference", status: false, expenseItems: []))
//}
