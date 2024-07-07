import SwiftUI

struct UserView<AuthenticationManager: AuthenticationManagerProtocol>: View {
    
    @State var isShowingSheet: Bool = false
    @State private var creditCardViewModel: CreditCardViewModel?
    @State private var selectedCurrency: String = ""
    @State private var isEditable = false
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            PFULogo()
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
    
    func initialize() {
        if let creditCard = authManager.user?.creditCard {
            creditCardViewModel = CreditCardViewModel(creditCardNumber: creditCard.cardNumber, expDate: creditCard.expirationDate)
        }
        selectedCurrency = authManager.user?.currency ?? ""
    }
    
    var content: some View {
        VStack {
            headerContent
            line
            userInformationView
            line
            creditCardView
            line
            HStack {
                CurrencyPicker(selectedCurrency: $selectedCurrency, isEditable: $isEditable)
                Button(action: {
                    isEditable.toggle()
                }) {
                    Image(systemName: isEditable ? "pencil.slash" : "pencil")
                        .font(.title3)
                }           .foregroundStyle(.oceanBlue)
            }.padding(.vertical)
            line
            changePassword
            logOut
            Spacer()
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
    
    var userInformationView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Contact Details")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundStyle(.gray)
                    Text(authManager.user?.email ?? "")
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Image(systemName: "phone")
                        .foregroundStyle(.gray)
                    Text(authManager.user?.phone_number ?? "")
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.vertical)
        }
    }
    
    var creditCardView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Saved Credit Card")
                .font(Font.custom("Nunito", size: 16).weight(.bold))
                .foregroundStyle(.oceanBlue)
            if let viewModel = creditCardViewModel {
                VStack(spacing: 10) {
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
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Exp: ")
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                        Text(viewModel.expDate)
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                    }.frame(maxWidth: .infinity, alignment: .leading)
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
    
    var changePassword: some View {
        Text("Forgot your password?")
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .padding()
    }
    
    var logOut: some View {
        NavigationLink(destination: SignInView().environmentObject(authManager)) {
            Text("Sign Out")
                .fontWeight(.bold)
                .foregroundColor(.red)
        }
        .simultaneousGesture(TapGesture().onEnded {
            authManager.signOut()
        })
    }
    
    func getLastFourCharacters(from string: String) -> String {
        let length = string.count
        if length < 4 {
            return string
        }
        let startIndex = string.index(string.endIndex, offsetBy: -4)
        let lastFour = string[startIndex...]
        return String(lastFour)
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
}

#Preview {
    UserView<MockAuthManager>()
        .environmentObject(MockAuthManager())
}
