//
//  NewCreditCardForm.swift
//  ExpenseManagement
//
//  Created by infra on 02/06/24.
//

import SwiftUI

struct NewCreditCardForm: View {
    
    @Environment(\.dismiss) var dismiss
    
//    let user: User?
    
    @State var creditCardNumberField: String = ""
    
    @State var expDate: String = ""
    
    @State var cvv: String = ""
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            ourPfu
            VStack {
                content
            }.padding()
        }.navigationBarBackButtonHidden()
    }
    
    var ourPfu: some View {
        VStack {
            HStack {
                Spacer()
                Image("pfuLogo")
                    .padding(.top, 40)
                    .padding(.trailing, 20)
            }
            Spacer()
        }.ignoresSafeArea()
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            creditCardNumberContainer
            HStack {
                expDateContainer
                cvvContainer
            }
            Spacer()
            saveButton
            backButton
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(authManager.user?.first_name ?? "")
                    .font(.system(size: 17).weight(.semibold))
                Text(authManager.user?.department ?? "")
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
    
    var creditCardNumberContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Card Number")
            TextField("xxxx.xxxx.xxxx.xxxx", text: $creditCardNumberField)
                .autocapitalization(.none)
                .autocorrectionDisabled(true) // Disable autocorrect
                .frame(height: 40)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }.padding(.top)
    }
    
    var expDateContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Expiration Date")
            TextField("MM/YY", text: $expDate)
                .autocapitalization(.none)
                .autocorrectionDisabled(true) // Disable autocorrect
                .frame(height: 40)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }.padding(.top)
    }
    
    var cvvContainer: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("CVV")
            TextField("ex: 123", text: $cvv)
                .autocapitalization(.none)
                .autocorrectionDisabled(true) // Disable autocorrect
                .frame(height: 40)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }.padding(.top)
    }
    
    var saveButton: some View {
        Button(action: {
            // save new credit card
        }, label: {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.blue)
                    Text("Save")
                        .foregroundStyle(.white)
                        .font(.system(size: 17).weight(.semibold))
                }
            }
        }).frame(height: 41)
    }
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.gray)
                    Text("Cancel")
                        .foregroundStyle(.white)
                        .font(.system(size: 17).weight(.semibold))
                }
            }
        }).frame(height: 41)
    }
}

#Preview {
    NewCreditCardForm()
}
