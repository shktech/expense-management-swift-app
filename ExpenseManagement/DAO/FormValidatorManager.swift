//
//  FormValidatorManager.swift
//  ExpenseManagement
//
//  Created by infra on 08/07/24.
//
import Foundation
import FormValidator

class FormValidatorManager: ObservableObject {
    // 2
    @Published
    var manager = FormManager(validationType: .immediate)

    // 3
    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var firstName: String = ""

    // 4
    lazy var firstNameValidation = _firstName.validation(manager: manager)
}
