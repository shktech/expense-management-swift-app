import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isPasswordVisible: Bool = false
    @State var confirmPassword: String = ""
    @State var isConfirmPasswordVisible: Bool = false
    @State var rememberMe: Bool = false
    @State var department: String = ""
    @State var selectedCurrency: String = "USD"
    @State var phoneNumber: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var registrationStatus = ""
    @State var isLoading: Bool = false
    
    @State private var navigationDestination: NavigationDestination? = nil
    
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ScrollView {
            ZStack {
                PFULogo().padding(.top, -80)
                content
                    .loadingOverlay(isLoading: $isLoading)
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
        }
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
        }.ignoresSafeArea(.keyboard, edges: .bottom)
        .padding(.horizontal)
        .padding(.bottom, 50)
    }
    
    var loginText: some View {
        HStack {
            Text("Already have an account? ")
                .font(.system(size: 13))
                .foregroundColor(.black)
            Text("Log in")
                .font(.system(size: 13).weight(.bold))
                .foregroundColor(.black)
                .onTapGesture {
                    navigationDestination = .signInView
                }
        }
    }
    
    var registerText: some View {
        HStack {
            Text("Register")
                .font(Font.custom("Poppins", size: 30).weight(.bold))
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
            CurrencyPicker(selectedCurrency: $selectedCurrency)
        }
    }
    
    var firstNameLastNameContainer: some View {
        HStack(spacing: 10) {
            firstNameContainer
            lastNameContainer
        }
    }
    
    var firstNameContainer: some View {
        VStack(alignment: .leading) {
            Text("First Name")
                .font(.system(size: 13).weight(.semibold))
                .foregroundStyle(.black)
                TextField("", text: $firstName)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
        
        var lastNameContainer: some View {
            VStack(alignment: .leading) {
                Text("Last Name")
                    .font(.system(size: 13).weight(.semibold))
                    .foregroundStyle(.black)
                TextField("", text: $lastName)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
        
        var emailContainer: some View {
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.system(size: 13).weight(.semibold))
                    .foregroundStyle(.black)
                TextField("\("example@pfu-us.ricoh.com")", text: $email)
                    .foregroundColor(.gray)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
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
            }
        }
        
        var confirmPasswordContainer: some View {
            VStack(alignment: .leading) {
                Text("Confirm Password")
                    .font(.system(size: 13).weight(.semibold))
                    .foregroundStyle(.black)
                confirmPasswordFieldContainer
            }
        }
        
        var passwordFieldContainer: some View {
            ZStack(alignment: .trailing) {
                if isPasswordVisible {
                    TextField("must be 9 characters or longer", text: $password)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                } else {
                    SecureField("must be 9 characters or longer", text: $password)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
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
        
        var confirmPasswordFieldContainer: some View {
            ZStack(alignment: .trailing) {
                if isConfirmPasswordVisible {
                    TextField("repeat password", text: $confirmPassword)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                } else {
                    SecureField("repeat password", text: $confirmPassword)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                }
                Button(action: {
                    isConfirmPasswordVisible.toggle()
                }) {
                    Image(systemName: isConfirmPasswordVisible ? "eye.fill" : "eye.slash")
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
        
        var departmentContainer: some View {
            VStack(alignment: .leading) {
                Text("Department")
                    .font(.system(size: 13).weight(.semibold))
                    .foregroundStyle(.black)
                TextField("", text: $department)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
        
        var phoneNumberInputView: some View {
            PhoneNumberInputView(fullPhoneNumber: $phoneNumber)
        }
        
        var bottomContent: some View {
            VStack {
                Button(action: {
                    isLoading = true
                    authManager.register(email: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, department: department, currency: selectedCurrency) { result in
                        isLoading = false
                        switch result {
                        case .success(let response):
                            if response == "Two-factor authentication required" {
                                navigationDestination = .verifyMFAView
                            } else {
                                navigationDestination = .signInView
                            }
                        case .failure(let error):
                            registrationStatus = "Registration failed: \(error.localizedDescription)"
                        }
                    }
                }, label: {
                    Text("Sign Up")
                        .font(.system(size: 17).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                        .background(Color.oceanBlue)
                        .cornerRadius(10)
                })
                loginText.padding()
                Text(registrationStatus)
                    .foregroundColor(.red)
            }
        }
    }

    #Preview {
        SignUpView()
    }
