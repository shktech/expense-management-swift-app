//
//  SignInView.swift
//  ExpenseManagement
//
//  Created by infra on 30/05/24.
//

import SwiftUI

struct SignInView: View {
    @State var emailField: String = ""
    @State var passwordField: String = ""
    @State var isPasswordVisible: Bool = false
    @State var rememberMe: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundImage()
            PFULogo()
            content
        }
    }
    
    var content: some View {
        VStack {
            Spacer()
            signInText
            Spacer()
            emailContainer
                .padding(.bottom)
            passwordContainer
            Spacer()
            bottomContent
            Spacer()
        }.padding()
    }
    
    var signInText: some View {
        Text("Sign in")
            .font(.system(size: 32).weight(.semibold))
            .foregroundStyle(Color(uiColor: .darkGray))
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
    
    var bottomContent: some View {
        VStack {
            Button(action: {
                // Sign In
            }, label: {
                Text("Sign In")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 349, height: 55)
                    .background(Color.blue)
                    .cornerRadius(14)
            })
            HStack {
                Button(action: {
                    rememberMe.toggle()
                }) {
                    Image(systemName: rememberMe ? "checkmark.square" : "square")
                        .foregroundColor(rememberMe ? .blue : .gray)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(PlainButtonStyle())

                Text("Remember Me")
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    SignInView()
}
