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
    
    @State private var keyboardHeight: CGFloat = 0
    
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
        Text("Sign in")
            .font(.system(size: 32).weight(.semibold))
            .foregroundStyle(Color(uiColor: .darkGray))
    }
    
    var fields: some View {
        VStack(spacing: 20) {
            emailContainer
            passwordContainer
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
            HStack {
                Button(action: {
                    withAnimation(Animation.linear(duration: 0.2)) {
                        rememberMe.toggle()
                    }
                }) {
                    Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                        .foregroundStyle(rememberMe ? .white : Color.secondary, Color(UIColor.systemBlue))
                }
                .buttonStyle(PlainButtonStyle())

                Text("Remember Me")
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
            }
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
            Button(action: {
                // Forgot Password
            }, label: {
                Text("Forgot Password?")
                    .foregroundStyle(.black)
                    .font(.system(size: 13).weight(.semibold))
            })
            .padding()
        }
    }
}

struct KeyboardProvider: ViewModifier {
    
    var keyboardHeight: Binding<CGFloat>
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
                       perform: { notification in
                guard let userInfo = notification.userInfo,
                      let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                                                            
                self.keyboardHeight.wrappedValue = keyboardRect.height
                
            }).onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                         perform: { _ in
                self.keyboardHeight.wrappedValue = 0
            })
    }
}


public extension View {
    func keyboardHeight(_ state: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardProvider(keyboardHeight: state))
    }
}

#Preview {
    SignInView()
}
