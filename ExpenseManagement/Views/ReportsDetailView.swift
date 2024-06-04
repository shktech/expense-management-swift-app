//
//  ReportsDetailView.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI

struct ReportsDetailView: View {
    
    let report: Reports
    
    let user: User?
    
    @State var isShowingForm: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()
                ZStack {
                    ourPfu
                    content
                }.padding()
            }
        }.sheet(isPresented: $isShowingForm, content: {
            NewExpenseForm(isShowingSelf: $isShowingForm, report: report)
        })
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
            }
            Spacer()
        }.ignoresSafeArea()
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            reportHeader
            addNewButton
            expenseItems
            Spacer()
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(user?.name ?? "")
                    .font(.system(size: 17).weight(.semibold))
                Text(user?.department ?? "")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundStyle(Color.black.opacity(0.5))
            }
            .padding(.bottom)
            Spacer()
        }
    }
    
    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var reportHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("\(report.id)")
                    .font(.system(size: 32).weight(.semibold))
                Text(report.createdAt.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 17).weight(.semibold))
                Text(report.purpose)
                    .font(.system(size: 17).weight(.semibold))
//                Text("\(report.value.formatted()) USD")
//                    .font(.system(size: 17).weight(.semibold))
                Text(report.reportStatus)
                    .foregroundStyle(report.reportStatus == "Submitted" ? .green : .red)
                    .font(.system(size: 15))
            }
            Spacer()
        }
    }
    
    var addNewButton: some View {
        Button(action: {
            // Add new expense
            isShowingForm.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.black.opacity(0.5))
                Text("+ Add New Expense")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundStyle(.white)
            }
        }).frame(height: 45)
    }
    
    var expenseItems: some View {
        VStack {
            ScrollView {
                ForEach(report.expenseItems, id: \.self.id) { expense in
                    ExpenseComponent(expense: expense, report: report)
                }
            }
        }.padding(.top)
    }
}

//#Preview {
//    ReportsDetailView(report: Reports(name: "Exp 1020", date: Date(), purpose: "New Conference", status: false, expenseItems: [
//        ExpenseItem(type: .Food, date: Date(), value: 120, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "", expirationDate: Date()), currency: "USD"),ExpenseItem(type: .Food, date: Date(), value: 120, purpose: "New Conference", preferredPaymentMethod: CreditCard(cardNumber: "", expirationDate: Date()), currency: "USD")
//    ]), user: User(name: "John Doe", username: "johnDoe", email: "john.doe@example.com", password: "password123", department: "IT Department", reports: [], paymentMethods: [
//        CreditCard(cardNumber: "1234123412341234", expirationDate: Date().addingTimeInterval(-3600)),
//        CreditCard(cardNumber: "1234123412341234", expirationDate: Date())
//    ]))
//}
