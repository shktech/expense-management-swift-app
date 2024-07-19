import SwiftUI

struct UserView<AuthenticationManager: AuthenticationManagerProtocol>: View {
    
    @State private var creditCardViewModel: CreditCardViewModel?
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.ourLightGray
                    .ignoresSafeArea()
                ZStack {
                    content
                }.padding()
            }
        }
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
            }.padding(.vertical)
            Spacer()
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
        NavigationLink(destination: PaymentDetailView<AuthenticationManager>()) {
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
        NavigationLink(destination: DefaultCurrencyView<AuthenticationManager>()) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .foregroundStyle(.oceanBlue2)
                    .frame(width: 35 ,height: 35)
                Text("Default Currency")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.oceanBlue2)
            }
        }
    }
    
    var redefinePassword: some View {
        NavigationLink(destination: EmptyView()) { // Got to implement the logic to redefine the password
            HStack {
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .foregroundStyle(.oceanBlue2)
                    .frame(width: 35 ,height: 35)
                Text("Redefine Password")
                    .font(Font.custom("Nunito", size: 18).weight(.semibold))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.oceanBlue2)
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
    
}

#Preview {
    UserView<MockAuthManager>()
        .environmentObject(MockAuthManager())
}
