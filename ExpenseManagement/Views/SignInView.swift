import SwiftUI

enum NavigationDestination {
    case mainView
    case verifyMFAView
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
            }
            .navigationBarHidden(true)
//            .navigationDestination(for: NavigationDestination?.self) { destination in
//                switch destination {
//                case .mainView:
//                    TabViewContainer()
//                case .verifyMFAView:
//                    VerifyMFAView()
//                default:
//                    EmptyView()
//                }
//            }
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
    SignInView().environmentObject(AuthenticationManager())
}
