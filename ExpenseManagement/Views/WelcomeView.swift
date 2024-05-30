//
//  WelcomeView.swift
//  ExpenseManagement
//
//  Created by infra on 30/05/24.
//

import SwiftUI

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            BackgroundImage()
            PFULogo()
            content
        }
    }
    
    var content: some View {
        ZStack {
            mainText
            navigationButtons
        }
    }
    
    var mainText: some View {
        VStack {
            Text("Expense Management")
                .font(.system(size: 38).weight(.semibold))
                .foregroundColor(Color(uiColor: .darkGray))
                .frame(width: 250)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
        }
    }
    
    var navigationButtons: some View {
        VStack(spacing: 16) {
            Spacer()
            NavigationLink(destination: SignInView()) {
                Text("Sign In")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 349, height: 55)
                    .background(Color.blue)
                    .cornerRadius(14)
            }
            NavigationLink(destination: SignUpView()) {
                Text("Register")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.black)
                    .frame(width: 349, height: 55)
                    .background(Color.gray)
                    .cornerRadius(14)
            }
        }
        .padding(.bottom, 100)
    }
}


#Preview {
    WelcomeView()
}
