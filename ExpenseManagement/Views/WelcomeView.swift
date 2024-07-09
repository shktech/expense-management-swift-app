import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            BackgroundImage(opacity: 0.3)
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
                Text("SIGN IN")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 349, height: 55)
                    .background(Color.oceanBlue)
                    .cornerRadius(10)
            }
            NavigationLink(destination: SignUpView()) {
                Text("Create account")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.black)
                    .frame(width: 349, height: 55)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.oceanBlue, lineWidth: 1)
                    )

            }
        }
        .padding(.bottom, 100)
    }
}


#Preview {
    WelcomeView()
}
