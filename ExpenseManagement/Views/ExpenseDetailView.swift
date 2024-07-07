//
//  ExpenseDetailView.swift
//  ExpenseManagement
//
//  Created by infra on 04/06/24.
//

import SwiftUI

struct ExpenseDetailView: View {
    
    let expense: ExpenseItem
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            PFULogo()
            content
                .padding()
        }
    }
    
    var content: some View {
        VStack {
            expenseTypeContainer
            HStack {
                dateContainer
                currencyContainer
            }
            amountContainer
            justificationContainer
            fileContainer
            Spacer()
        }.padding()
    }
    
    var expenseTypeContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Expense Type")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                HStack {
                    Text("\(expense.expenseType)")
                        .foregroundStyle(.black)
                    Spacer()
                }.padding(.horizontal)
            }.frame(height: 41)

        }.padding(.top)
    }
    
    var dateContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Date")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                HStack {
                    if let date = DateFormatter.apiDate.date(from: expense.expenseDate) {
                        Text(DateFormatter.userFriendly.string(from: date))
                            .font(.system(size: 17))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }.padding(.horizontal)
            }.frame(height: 41)

        }.padding(.top)
    }
    
    var currencyContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Currency")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                HStack {
                    Text("\(expense.receiptCurrency)")
                        .foregroundStyle(.black)
                    Spacer()
                }.padding(.horizontal)
            }.frame(height: 41)

        }.padding(.top)
    }
    
    var amountContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Amount")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                HStack {
                    Text("\(expense.receiptAmount)")
                        .foregroundStyle(.black)
                    Spacer()
                }.padding(.horizontal)
            }.frame(height: 41)

        }.padding(.top)
    }
    
    var justificationContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Justification")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                HStack {
                    Text("\(expense.justification)")
                        .foregroundStyle(.black)
                    Spacer()
                }.padding(.horizontal)
            }.frame(height: 41)

        }.padding(.top)
    }
    
    var fileContainer: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Uploaded receipt")
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                HStack {
                    Text(expense.filename ?? "")
                        .foregroundStyle(.black)
                }.padding(.horizontal)
            }.frame(height: 41)

        }.padding(.top)
    }
}

#Preview {
    ExpenseDetailView(expense: ExpenseItem(
        id: "1",
        airline: nil,
        rentalAgency: nil,
        carType: nil,
        mealCategory: nil,
        relationshipToPAI: nil,
        city: nil,
        hotelDailyBaseRate: nil,
        mileageRate: nil,
        presignedURL: nil,
        filename: nil,
        expenseType: ExpenseType.airFare,
        expenseDate: "2024-06-24",
        receiptAmount: "120.99",
        receiptCurrency: "USD",
        justification: "Travel to Brazil",
        note: nil,
        s3Path: nil,
        originDestination: nil,
        employeeNames: nil,
        totalEmployees: nil,
        companyCustomerName: nil,
        businessTopic: nil,
        totalAttendees: nil,
        nameOfEstablishment: nil,
        hotelName: nil,
        carrier: nil,
        distance: nil,
        createdAt: nil,
        updatedAt: nil,
        report: nil
    ))
}
