//
//  DefaultCurrencyView.swift
//  ExpenseManagement
//
//  Created by Felipe on 19/07/24.
//

import SwiftUI

struct DefaultCurrencyView<AuthenticationManager: AuthenticationManagerProtocol>: View {
    
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedCurrency: String = ""
    @State private var isEditable = false
    
    @State private var isDefaultCurrencyFocused: Bool = false
    
    var didChange: Bool {
        return authManager.user?.currency != selectedCurrency
    }
    
    var body: some View {
        ZStack {
            Color.ourLightGray
                .ignoresSafeArea()
            ZStack {
                content
            }.padding()
        }
        .onAppear {
            selectedCurrency = authManager.user?.currency ?? ""
        }
    }
    
    var content: some View {
        VStack {
            headerContent
            currencyPickerComponent
            Spacer()
            Button(action: {
                // save changes
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.oceanBlue)
                    Text("Save")
                        .font(Font.custom("Poppins", size: 24).weight(.semibold))
                        .foregroundStyle(.white)
                }
            }).frame(height: 53)
            .opacity(didChange ? 1 : 0.5)
            .disabled(!didChange)
        }.padding()
    }
    
    var headerContent: some View {
        HStack {
            Text("Default Currency")
                .font(Font.custom("Nunito", size: 26).weight(.bold))
            Spacer()
            Image("pfuLogo")
                .resizable()
                .frame(width: 80, height: 40)
        }
    }
    
    var currencyPickerComponent: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Default Currency")
                    .font(Font.custom("Nunito", size: 16).weight(.semibold))
                    .foregroundStyle(.gray)
                HStack {
                    CurrencyPicker(selectedCurrency: $selectedCurrency, isEditable: $isEditable, title: "Default Concurrency", isFocused: $isDefaultCurrencyFocused)
                    Button(action: {
                        isEditable.toggle()
                    }) {
                        Image(systemName: isEditable ? "pencil.slash" : "pencil")
                            .font(.title3)
                            .foregroundStyle(.oceanBlue)
                    }
                }
            }
        }.padding(.vertical)
    }
}

#Preview {
    DefaultCurrencyView<MockAuthManager>()
        .environmentObject(MockAuthManager())
}
