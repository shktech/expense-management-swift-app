import SwiftUI

struct UserView<AuthenticationManager: AuthenticationManagerProtocol>: View {
    
    @State var isShowingSheet: Bool = false
    @State private var creditCardViewModel: CreditCardViewModel?
    @State private var selectedCurrency: String = ""
    @State private var isEditable = false
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var isDefaultCurrencyFocused: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("whiteBackground")
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
            userInfo
            line
            VStack(spacing: 30) {
                accountButton
                creditCardInfo
                defaultCurrency
                redefinePassword
                line
                logOut
                Spacer()
            }.padding(.vertical)
//            userInformationView
//            line
//            creditCardView
//            Spacer()
//            line
//            HStack {
//                CurrencyPicker(selectedCurrency: $selectedCurrency, isEditable: $isEditable, title: "Default Concurrency", isFocused: $isDefaultCurrencyFocused)
//                Button(action: {
//                    isEditable.toggle()
//                }) {
//                    Image(systemName: isEditable ? "pencil.slash" : "pencil")
//                        .font(.title3)
//                }           .foregroundStyle(.oceanBlue)
//            }.padding(.vertical)
//            changePassword
        }.padding()
    }
    
    var headerContent: some View {
        VStack {
            HStack {
                Text("Account")
                    .font(Font.custom("Nunito", size: 26).weight(.bold))
                    .foregroundStyle(.ourDarkGray)
                Spacer()
                Image("pfuLogo")
                    .resizable()
                    .frame(width: 80, height: 40)
            }
        }
    }
    
    var userInfo: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundStyle(.oceanBlue)
                    .frame(width: 67, height: 67)
                Text("\(authManager.user?.first_name.first?.description ?? "")\(authManager.user?.last_name.first?.description ?? "")")
                    .font(Font.custom("Nunito", size: 26).weight(.bold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading) {
                Text("\(authManager.user?.first_name ?? "") \(authManager.user?.last_name ?? "")")
                    .font(Font.custom("Nunito", size: 22).weight(.bold))
                    .foregroundStyle(.ourDarkGray)
                Text(authManager.user?.department ?? "")
                    .font(Font.custom("Nunito", size: 16).weight(.semibold))
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
    
    var line: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 1)
            .foregroundStyle(Color.gray.opacity(0.4))
    }
    
    var accountButton: some View {
        NavigationLink(destination: UserInformationView<AuthenticationManager>()) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.oceanBlue2)
                    .frame(width: 35 ,height: 35)
                Text("User Information")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.oceanBlue2)
            }
        }
    }
    
    var creditCardInfo: some View {
        NavigationLink(destination: EmptyView()) {
            HStack {
                Image(systemName: "creditcard.circle.fill")
                    .resizable()
                    .foregroundStyle(.oceanBlue2)
                    .frame(width: 35 ,height: 35)
                Text("Payment")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.oceanBlue2)
            }
        }
    }
    
    var defaultCurrency: some View {
        HStack {
            Image(systemName: "dollarsign.circle.fill")
                .resizable()
                .foregroundStyle(.oceanBlue2)
                .frame(width: 35 ,height: 35)
            Text("Default Currency")
                .font(Font.custom("Nunito", size: 18).weight(.semibold))
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundStyle(.oceanBlue2)
        }
    }
    
    var redefinePassword: some View {
        HStack {
            Image(systemName: "lock.circle.fill")
                .resizable()
                .foregroundStyle(.oceanBlue2)
                .frame(width: 35 ,height: 35)
            Text("Redefine Password")
                .font(Font.custom("Nunito", size: 18).weight(.semibold))
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundStyle(.oceanBlue2)
        }
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
