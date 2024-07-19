//
//  UserInformationView.swift
//  ExpenseManagement
//
//  Created by Felipe on 19/07/24.
//

import SwiftUI

struct UserInformationView<AuthenticationManager: AuthenticationManagerProtocol>: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            Image("whiteBackground")
                .ignoresSafeArea()
            content
                .padding()
        }
    }
    
    var content: some View {
        VStack(spacing: 15) {
            headerContent
            VStack {
                nameField
                emailField
                phoneNumberField
            }.padding(.vertical)
            Spacer()
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            Text("User Information")
                .foregroundStyle(.ourDarkGray)
                .font(Font.custom("Nunito", size: 26).weight(.bold))
            Spacer()
            Image("pfuLogo")
                .resizable()
                .frame(width: 80, height: 40)
        }
    }
    
    var nameField: some View {
        VStack(alignment: .leading) {
            Text("Name:")
                .font(Font.custom("Nunito", size: 16).weight(.semibold))
                .foregroundStyle(.gray)
            VStack(spacing: 3) {
                HStack {
                    Text("\(authManager.user?.first_name ?? "") \(authManager.user?.last_name ?? "")")
                        .font(Font.custom("Nunito", size: 22).weight(.bold))
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 1)
                    .foregroundStyle(Color.gray.opacity(0.4))
            }
        }
    }
    
    var emailField: some View {
        VStack(alignment: .leading) {
            Text("Email:")
                .font(Font.custom("Nunito", size: 16).weight(.semibold))
                .foregroundStyle(.gray)
            VStack(spacing: 3) {
                HStack {
                    Text("\(authManager.user?.email ?? "")")
                        .font(Font.custom("Nunito", size: 22).weight(.bold))
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 1)
                    .foregroundStyle(Color.gray.opacity(0.4))
            }
        }
    }
    
    var phoneNumberField: some View {
        VStack(alignment: .leading) {
            Text("Phone Number:")
                .font(Font.custom("Nunito", size: 16).weight(.semibold))
                .foregroundStyle(.gray)
            VStack(spacing: 3) {
                HStack {
                    Text("\(authManager.user?.phone_number ?? "")")
                        .font(Font.custom("Nunito", size: 22).weight(.bold))
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 1)
                    .foregroundStyle(Color.gray.opacity(0.4))
            }
        }
    }
}

#Preview {
    UserInformationView<MockAuthManager>()
        .environmentObject(MockAuthManager())
}
