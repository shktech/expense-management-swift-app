import SwiftUI

enum NavigationDestination {
    case mainView
    case verifyMFAView
    case signInView
    case signUpView
}

struct SignInView: View {
    @State var emailField: String = ""
    @State var passwordField: String = ""
    @State var isPasswordVisible: Bool = false
    @State var rememberMe: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var isLoading = false
    @State private var navigationDestination: NavigationDestination? = nil
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage(opacity: 0.3)
                PFULogo()
                content.loadingOverlay(isLoading: $isLoading)
                NavigationLink(
                    tag: NavigationDestination.mainView,
                    selection: $navigationDestination,
                    destination: { TabViewContainer() },
                    label: { EmptyView() }
                )
                NavigationLink(
                    tag: NavigationDestination.verifyMFAView,
                    selection: $navigationDestination,
                    destination: { VerifyMFAView() },
                    label: { EmptyView() }
                )
                NavigationLink(
                    tag: NavigationDestination.signInView,
                    selection: $navigationDestination,
                    destination: { SignInView() },
                    label: { EmptyView() }
                )
                NavigationLink(
                    tag: NavigationDestination.signUpView,
                    selection: $navigationDestination,
                    destination: { SignUpView() },
                    label: { EmptyView() }
                )
            }
            .navigationBarHidden(true)
        }
    }
    
    var content: some View {
        VStack(spacing: 50) {
            signInText
            if authManager.loginFailed {
                Text("Incorrect email or password")
                    .foregroundStyle(.red)
                    .font(.system(size: 14).weight(.semibold))
            }
            fields
            bottomContent
            signUpText
        }.padding()
    }
    
    var signInText: some View {
        Text("Sign in")
            .font(.system(size: 32).weight(.semibold))
            .foregroundStyle(Color(uiColor: .darkGray))
    }
    
    var signUpText: some View {
        HStack {
            Text("Don’t have an account? ")
                .font(.system(size: 13))
                .foregroundColor(.black)
            Text("Sign up")
                .font(.system(size: 13).weight(.bold))
                .foregroundColor(.black)
                .onTapGesture {
                    navigationDestination = .signUpView
                }
        }
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
                .frame(height: 50)
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
                        .foregroundStyle(rememberMe ? .white : Color.secondary, Color(UIColor.oceanBlue))
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
        .frame(height: 50)
        .padding(.horizontal, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    var bottomContent: some View {
        VStack {
            Button(action: {
                isLoading = true
                authManager.signIn(email: emailField, password: passwordField) { result in
                    print("setting isloading to false")
                    isLoading = false
                    switch result {
                    case .success(_):
                        navigationDestination = .mainView
                    case .failure(let error):
                        if let nsError = error as NSError?, nsError.code == -1, nsError.userInfo["code"] as? String == "second_factor_required" {
                            print("Setting navigationDestination to verifyMFA")
                            navigationDestination = .verifyMFAView                        }
                        //                        print(error)
                    }
                }
            }, label: {
                Text("Sign In")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 349, height: 55)
                    .background(Color.oceanBlue)
                    .cornerRadius(14)
            })
            Button(action: {
            }, label: {
                Text("Forgot Password?")
                    .foregroundStyle(.black)
                    .font(.system(size: 13).weight(.semibold))
            })
            .padding()
        }
    }
}

#Preview {
    SignInView().environmentObject(AuthenticationManager())
}
