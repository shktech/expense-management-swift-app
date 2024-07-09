import Combine
import UIKit
import FormValidator

class SignUpForm: ObservableObject {
    @Published var manager = FormManager(validationType: .immediate)
    
    @FormField(validator: NonEmptyValidator(message: "First name is required"))
    var firstName: String = ""
    lazy var firstNameValidation = _firstName.validation(manager: manager)

    @FormField(validator: NonEmptyValidator(message: "Last name is required"))
    var lastName: String = ""
    lazy var lastNameValidation = _lastName.validation(manager: manager)

    @FormField(validator: EmailValidator(message: "Invalid email"))
    var email: String = ""
    lazy var emailValidation = _email.validation(manager: manager)

    @PasswordFormField(message: (
        empty: "Password is required",
        notMatching: "Passwords do not match",
        invalidPattern: "Your password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."
    ))
    var password: String = ""
    lazy var passwordValidation = _password.validation(
        manager: manager,
        other: _confirmPassword,
        pattern: try! NSRegularExpression(
            pattern: "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[-_@$!%*#?&])[A-Za-z\\d-_@$!%*#?&]{8,}$",
            options: .caseInsensitive)
    )

    @PasswordFormField(message: (
        empty: "Confirm password is required",
        notMatching: "Passwords do not match",
        invalidPattern: "Your password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."
    ))
    var confirmPassword: String = ""
    lazy var confirmPasswordValidation = _confirmPassword.validation(
        manager: manager,
        other: _password,
        pattern: try! NSRegularExpression(
            pattern: "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[-_@$!%*#?&])[A-Za-z\\d-_@$!%*#?&]{8,}$",
            options: .caseInsensitive)
    )

    @FormField(validator: NonEmptyValidator(message: "Phone number is required"))
    var phoneNumber: String = ""
    lazy var phoneNumberValidation = _phoneNumber.validation(manager: manager)

    @FormField(validator: NonEmptyValidator(message: "Department is required"))
    var department: String = ""
    lazy var departmentValidation = _department.validation(manager: manager)
}
