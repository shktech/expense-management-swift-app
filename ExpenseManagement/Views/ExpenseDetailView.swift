//
//  ExpenseDetailView.swift
//  ExpenseManagement
//
//  Created by infra on 04/06/24.
//

import SwiftUI

struct ExpenseDetailView: View {
    
    let expense: ExpenseItem
    
    let report: Reports
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
        }
    }
}

//#Preview {
//    ExpenseDetailView(expense: ExpenseItem(type: .Hotel, date: Date(), value: 129, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "1234123412341234", expirationDate: Date()), currency: "USD"), report: Reports(name: "Exp 1020", date: Date(), purpose: "New Conference", status: false, expenseItems: []))
//}
