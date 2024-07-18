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
    @State private var isBiometricsEnabled: Bool = false
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var globalState: GlobalStateManager
    @StateObject private var biometricAuthViewModel = BiometricAuthenticationProvider()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage(opacity: 0.3)
                PFULogo()
                content
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
            .loadingOverlay(isLoading: $isLoading)
        }
        .onAppear {
            if let credentials = KeychainHelper.load(key: "default") as? [String: Any] {
                rememberMe = credentials["rememberEmail"] as? Bool ?? false
                if rememberMe {
                    emailField = credentials["email"] as? String ?? ""
                }
                biometricAuthViewModel.isBiometricEnabled = credentials["biometricEnabled"] as? Bool ?? false
                if biometricAuthViewModel.isBiometricEnabled {
                    biometricAuthViewModel.authenticate { success in
                        if success {
                            passwordField = credentials["password"] as? String ?? ""
                            signIn()
                        }
                    }
                }
            }
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            signInText
            fields
            bottomContent
//            signUpText
        }.padding()
    }

    var signInText: some View {
        Text("Sign In")
            .font(.system(size: 24).weight(.semibold))
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
        VStack(spacing: 10) {
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
            Button(action: {
            }, label: {
                Text("Forgot Password?")
                    .foregroundStyle(.black)
                    .font(.system(size: 13).weight(.semibold))
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember Me")
                            .font(.system(size: 13).weight(.semibold))
                            .foregroundStyle(.black)
                    }
                    .toggleStyle(SmallToggleStyle())
                }
                HStack {
                    Toggle(isOn: $isBiometricsEnabled) {
                        Text("Enable Biometric Login")
                            .font(.system(size: 13).weight(.semibold))
                            .foregroundStyle(.black)
                    }
                    .toggleStyle(SmallToggleStyle())
                }
            }
            .padding(.top, 10)
        }
        .padding(.vertical)
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
                if isBiometricsEnabled {
                    signInWithBiometrics()
                } else {
                    signIn()
                }
            }, label: {
                Text("Sign In")
                    .font(.system(size: 18).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 349, height: 55)
                    .background(Color.oceanBlue)
                    .cornerRadius(14)
            })
            signUpText
                .padding(.top)
        }
    }

    private func signInWithBiometrics() {
        biometricAuthViewModel.authenticate {
            success in
            if success {
                biometricAuthViewModel.saveBiometricEnabled(true, for: emailField)
                signIn()
            }
        }
    }

    private func signIn() {
        isLoading = true
        authManager.signIn(email: emailField, password: passwordField) { result in
            switch result {
            case .success(_):
                if biometricAuthViewModel.isBiometricEnabled || rememberMe {
                    biometricAuthViewModel.saveCredentials(email: emailField, password: passwordField, biometricEnabled: isBiometricsEnabled, rememberEmail: rememberMe)
                }
//                if rememberMe {
//                    KeychainHelper.save(rememberMe, forKey: "rememberMe")
//                    KeychainHelper.save(emailField, forKey: "email")
//                } else {
//                    KeychainHelper.save(rememberMe, forKey: "rememberMe")
//                    KeychainHelper.delete(key: "email")
//                }
                isLoading = false
                navigationDestination = .mainView
            case .failure(let error):
                if let nsError = error as NSError?, nsError.code == -1, nsError.userInfo["code"] as? String == "second_factor_required" {
                    print("Setting navigationDestination to verifyMFA")
                    isLoading = false
                    navigationDestination = .verifyMFAView
                } else {
                    isLoading = false
                    globalState.showMessage(title: "Error", message: "Incorrect email or password", type: .error)
                }
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthenticationManager())
        .environmentObject(GlobalStateManager())
}
