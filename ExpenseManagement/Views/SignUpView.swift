import SwiftUI

struct SignUpView: View {
    @ObservedObject var form = FormValidatorManager()
    @State var isPasswordVisible: Bool = false
    @State var isConfirmPasswordVisible: Bool = false
    @State var selectedCurrency: String = "USD"
    @State var phoneNumber: String = ""
    @State var isLoading: Bool = false
    @State private var navigationDestination: NavigationDestination? = nil
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var globalState: GlobalStateManager

    var body: some View {
        ScrollView {
            ZStack {
                PFULogo().padding(.top, -80)
                content
                    .ignoresSafeArea(.keyboard, edges: .bottom)
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
            }
        }.loadingOverlay(isLoading: $isLoading)
    }

    var content: some View {
        VStack {
            registerText.padding()
            ScrollView {
                innerContent
            }
        }.padding(.top, 50)
    }

    var innerContent: some View {
        VStack(spacing: 30) {
            fields
            bottomContent
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding(.horizontal)
        .padding(.bottom, 50)
    }

    var loginText: some View {
        HStack {
            Text("Already have an account? ")
                .font(.system(size: 13))
                .foregroundColor(.black)
            Text("SIGN IN")
                .font(.system(size: 13).weight(.bold))
                .foregroundColor(.black)
                .onTapGesture {
                    navigationDestination = .signInView
                }
        }
    }

    var registerText: some View {
        HStack {
            Text("Create your account")
                .font(Font.custom("Nunito", size: 30).weight(.heavy))
                .foregroundColor(.black)
            Spacer()
        }
    }

    var fields: some View {
        VStack(spacing: 10) {
            firstNameLastNameContainer
            emailContainer
            passwordContainer
            confirmPasswordContainer
            phoneNumberInputView
            departmentContainer
            CurrencyPicker(selectedCurrency: $selectedCurrency, isEditable: .constant(true), title: "Default Currency")
        }
    }

    var firstNameLastNameContainer: some View {
        HStack(spacing: 10) {
            TextInputView(title: "First Name", text: $form.firstName, isEditable: .constant(true), validation: form.firstNameValidation, placeholder: "")
            TextInputView(title: "Last Name", text: $form.lastName, isEditable: .constant(true), validation: form.lastNameValidation, placeholder: "")
        }
    }

    var emailContainer: some View {
        TextInputView(title: "Email", text: $form.email, isEditable: .constant(true), validation: form.emailValidation, placeholder: "example@pfu-us.ricoh.com")
    }

    var passwordContainer: some View {
        PasswordInputView(title: "Password", password: $form.password, isPasswordVisible: $isPasswordVisible, isEditable: .constant(true), validation: form.passwordValidation, placeholder: "must be 9 characters or longer")
    }

    var confirmPasswordContainer: some View {
        PasswordInputView(title: "Confirm Password", password: $form.confirmPassword, isPasswordVisible: $isConfirmPasswordVisible, isEditable: .constant(true), validation: form.confirmPasswordValidation, placeholder: "repeat password")
    }

    var departmentContainer: some View {
        TextInputView(title: "Department", text: $form.department, isEditable: .constant(true), validation: form.departmentValidation, placeholder: "")
    }

    var phoneNumberInputView: some View {
        PhoneNumberInputView(fullPhoneNumber: $phoneNumber)
    }

    var bottomContent: some View {
        VStack {
            Button(action: {
            var formValid: Bool = form.manager.triggerValidation()
                if (formValid) {
                    isLoading = true
                    signUp()
                }
            }, label: {
                Text("SIGN UP")
                    .font(.system(size: 17).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                    .background(Color.oceanBlue)
                    .cornerRadius(10)
            })
            loginText.padding()
        }
    }
    
    func signUp() {
        authManager.register(email: form.email, password: form.password, firstName: form.firstName, lastName: form.lastName, phoneNumber: phoneNumber, department: form.department, currency: selectedCurrency) { result in
            isLoading = false
            switch result {
            case .success(let response):
                if response == "Two-factor authentication required" {
                    navigationDestination = .verifyMFAView
                } else {
                    navigationDestination = .signInView
                    globalState.showMessage(title: "Success", message: "Registration successful, please login", type: .success)
                }
            case .failure(let error):
                globalState.showMessage(title: "Error", message: "Registration failed, Please try a different email address and a phone number to register or sign in", type: .error)
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationManager())
        .environmentObject(GlobalStateManager())
}
