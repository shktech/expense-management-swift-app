//
//  PaymentDetailView.swift
//  ExpenseManagement
//
//  Created by Felipe on 19/07/24.
//

import SwiftUI

struct PaymentDetailView<AuthenticationManager: AuthenticationManagerProtocol>: View {
    
    @State var isShowingSheet: Bool = false
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var creditCardViewModel: CreditCardViewModel?
    @State private var selectedCurrency: String = ""
    
    var body: some View {
        ZStack {
            Color.ourLightGray
                .ignoresSafeArea()
            ZStack {
                content
            }.padding()
        }.sheet(isPresented: $isShowingSheet, onDismiss: {
            reloadUserData()
        }, content: {
            NewCreditCardForm()
                .presentationDetents([.fraction(0.5)])
        }).onAppear(perform: initialize)
    }
    
    var content: some View {
        VStack {
            headerContent
            creditCardView
            Spacer()
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            Text("Payment")
                .font(Font.custom("Nunito", size: 26).weight(.bold))
            Spacer()
            Image("pfuLogo")
                .resizable()
                .frame(width: 80, height: 40)
        }
    }
    
    var creditCardView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let viewModel = creditCardViewModel {
                VStack(spacing: 10) {
                    VStack(alignment: .leading ,spacing: 3) {
                        Text("Creadit Card Number")
                            .foregroundStyle(.gray)
                            .font(Font.custom("Nunito", size: 16).weight(.semibold))
                        HStack {
                            if viewModel.cardIcon == "creditcard" {
                                Image(systemName: viewModel.cardIcon)
                                    .foregroundColor(.gray)
                            } else {
                                Image(viewModel.cardIcon)
                                    .resizable()
                                    .frame(width: 30, height: 24)
                            }
                            Text(viewModel.creditCardNumberField)
                                .font(Font.custom("Nunito", size: 22))
                                .foregroundStyle(.ourDarkGray)
                                .fontWeight(.semibold)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 1)
                            .foregroundStyle(Color.gray.opacity(0.4))
                    }
                    VStack(alignment: .leading ,spacing: 3) {
                        Text("Expiration Date")
                            .foregroundStyle(.gray)
                            .font(Font.custom("Nunito", size: 16).weight(.semibold))
                        HStack {
                            Text(viewModel.expDate)
                                .font(Font.custom("Nunito", size: 22))
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 1)
                            .foregroundStyle(Color.gray.opacity(0.4))
                    }
                }.padding(.vertical)
            } else {
                Button(action: {
                    isShowingSheet.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray)
                        Text("+ Add Credit Card")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                }).frame(height: 50).padding(.vertical)
            }
        }
    }
    
    func reloadUserData() {
        authManager.loadUserData { result in
            switch result {
            case .success:
                print("User data reloaded successfully")
            case .failure(let error):
                print("Failed to reload user data: \(error)")
            }
        }
    }
    
    func initialize() {
        if let creditCard = authManager.user?.creditCard {
            creditCardViewModel = CreditCardViewModel(creditCardNumber: creditCard.cardNumber, expDate: creditCard.expirationDate)
        }
        selectedCurrency = authManager.user?.currency ?? ""
    }
}

#Preview {
    PaymentDetailView<MockAuthManager>()
        .environmentObject(MockAuthManager())
}
