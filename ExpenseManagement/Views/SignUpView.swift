//
//  SignUpView.swift
//  ExpenseManagement
//
//  Created by infra on 30/05/24.
//

import SwiftUI

struct SignUpView: View {
    @State var emailField: String = ""
    @State var passwordField: String = ""
    @State var isPasswordVisible: Bool = false
    @State var confirmPasswordField: String = ""
    @State var isConfirmPasswordVisible: Bool = false
    @State var rememberMe: Bool = false
    
    @State private var keyboardHeight: CGFloat = 0
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var email = "ex2@ex2.com"
    @State private var password = "1234"
    @State private var firstName = "John"
    @State private var lastName = "Doe"
    @State private var phoneNumber = "+1555123-4567"
    @State private var registrationStatus = ""
    
    var body: some View {
        ZStack {
            BackgroundImage()
            PFULogo()
            content
        }
    }
    
    var content: some View {
        VStack(spacing: 50) {
            signInText
            fields
            bottomContent
        }.padding()
    }
    
    var signInText: some View {
        Text("Sign Up")
            .font(.system(size: 32).weight(.semibold))
            .foregroundStyle(Color(uiColor: .darkGray))
    }
    
    var fields: some View {
        VStack(spacing: 20) {
            emailContainer
            passwordContainer
            confirmPasswordContainer
        }
    }
    
    var emailContainer: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.system(size: 13).weight(.semibold))
                .foregroundStyle(.black)
            TextField("", text: $emailField)
                .autocapitalization(.none)
                .autocorrectionDisabled(true) // Disable autocorrect
                .frame(height: 40)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
    
    var passwordContainer: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .font(.system(size: 13).weight(.semibold))
                .foregroundStyle(.black)
            passwordFieldContainer
        }
    }
    
    var confirmPasswordContainer: some View {
        VStack(alignment: .leading) {
            Text("Confirm Password")
                .font(.system(size: 13).weight(.semibold))
                .foregroundStyle(.black)
            confirmPasswordFieldContainer
        }
    }
    
    var passwordFieldContainer: some View {
        ZStack(alignment: .trailing) {
            if isPasswordVisible {
                TextField("", text: $passwordField)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true) // Disable autocorrect
            } else {
                SecureField("", text: $passwordField)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true) // Disable autocorrect
            }
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash")
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    var confirmPasswordFieldContainer: some View {
        ZStack(alignment: .trailing) {
            if isConfirmPasswordVisible {
                TextField("", text: $confirmPasswordField)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true) // Disable autocorrect
            } else {
                SecureField("", text: $confirmPasswordField)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true) // Disable autocorrect
            }
            Button(action: {
                isConfirmPasswordVisible.toggle()
            }) {
                Image(systemName: isConfirmPasswordVisible ? "eye.fill" : "eye.slash")
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    var bottomContent: some View {
        VStack {
            Button(action: {
                // Sign Up
                authManager.register(email: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber) { result in
                    switch result {
                    case .success:
                        registrationStatus = "Registration successful"
                    case .failure(let error):
                        registrationStatus = "Registration failed: \(error.localizedDescription)"
                    }
                }
            }, label: {
                Text("Sign Up")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 349, height: 55)
                    .background(Color.blue)
                    .cornerRadius(14)
            })
        }
    }
}

#Preview {
    SignUpView()
}
