//
//  UserView.swift
//  ExpenseManagement
//
//  Created by infra on 31/05/24.
//

import SwiftUI

struct UserView: View {
    
    let user: User?
    
    @State var isShowingSheet: Bool = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            PFULogo()
            ZStack {
                content
            }.padding()
        }.sheet(isPresented: $isShowingSheet, content: {
            ManagePaymentView(user: user, isShowing: $isShowingSheet)
        })
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            usernameField
            emailField
            changePassword
            Spacer()
            manageFinancesButton
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
    
    var usernameField: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Username")
                .foregroundStyle(.gray)
                .fontWeight(.semibold)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
                    .frame(height: 41)
                    .foregroundStyle(Color(uiColor: .systemGray6))
                HStack {
                    Text(user?.username ?? "")
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundStyle(Color.blue)
                }.padding()
            }
        }
    }
    
    var emailField: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Email")
                .foregroundStyle(.gray)
                .fontWeight(.semibold)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
                    .frame(height: 41)
                    .foregroundStyle(Color(uiColor: .systemGray6))
                HStack {
                    Text(user?.email ?? "")
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundStyle(Color.blue)
                }.padding()
            }
        }
    }
    
    var changePassword: some View {
        Text("Forgot your password?")
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .padding()
    }
    
    var manageFinancesButton: some View {
        Button(action: {
            isShowingSheet.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.gray)
                Text("Manage Payment Methods")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
            }
        }).frame(height: 41)
    }
}

#Preview {
    UserView(user: User(name: "John Doe", username: "johnDoe", email: "john.doe@example.com", password: "password123", department: "IT Department", reports: [], paymentMethods: [
        CreditCard(cardNumber: "1234123412341234", expirationDate: Date().addingTimeInterval(-3600)),
        CreditCard(cardNumber: "1234123412341234", expirationDate: Date())
    ]))
}
