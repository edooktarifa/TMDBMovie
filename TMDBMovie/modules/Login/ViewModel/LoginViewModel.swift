//
//  LoginViewModel.swift
//  TMDBMovie
//
//  Created by Phincon on 11/07/21.
//

import Foundation
import UIKit
import Alamofire

enum ValidationError: Error {
    case emptyUsername
    case emptyPassword
    case invalidEmailAddress
    case noError
    
    var localizedDescription : String {
        switch self {
        case .emptyUsername:
            return "Please enter the username"
        case .emptyPassword:
            return "Please enter the password"
        case .invalidEmailAddress:
            return "Please enter a valid email address"
        case .noError:
            return ""
        }
    }
}

struct TextfieldError {
    var email: String?
    var password: String?
}

class LoginViewModel {
    var isLoading = Bindable(false)
    var loginToken : Bindable<LoginModel?> = Bindable(nil)
    var loginSucces: Bindable<LoginModel?> = Bindable(nil)
    var showError : Bindable<AlertError?> = Bindable(nil)
    var showErrorTextFields: Bindable <TextfieldError?> = Bindable(nil)

    // MARK:with clousure
    var showErrorTextField: ((_ email: String?, _ password: String?) -> Void)?
    
    func fetchGetTokenApi(){
        let param : Parameters = ["api_key": Constant.apiKey]
        APIServices.shared.request(url: Constant.baseUrl + "3/authentication/token/new", method: .get, params: param, encoding: URLEncoding.default, headers: nil) { [weak self](_ result: LoginModel?, _ errorModel: BaseErrorModel?, error) in
            
            guard let self = self else { return }
            
            self.isLoading.value = false
            
            if let _ = error {
                self.showErrors(title: "Error", description: "Please check your connection")
            } else if let errorModel = errorModel {
                self.showErrors(title: "Error", description: errorModel.status_message ?? "")
            } else {
                if let result = result {
                    self.loginToken.value = result
                }
            }
        }
    }
    
    func validateInput(email: String, password: String) -> ValidationError? {
        if email.isEmpty {
            return .emptyUsername
        } else if password.isEmpty {
            return .emptyPassword
        }
//        else if !validateEmail(email: email){
//            return .invalidEmailAddress
//        }
        
        return nil
    }
    
    func validateEmail(email: String) -> Bool{
        let regex = "([\\w-+]+(?:\\.[\\w-+]+)*@(?:[\\w-]+\\.)+[a-zA-Z]{2,7})"
        let validateEmail = NSPredicate(format: "SELF MATCHES %@", regex)
        return validateEmail.evaluate(with: email)
    }
    
    func validateInputTextField(email: String, password: String){
        if email.isEmpty {
            self.showErrorTextField?(ValidationError.emptyUsername.localizedDescription, nil)
        } else if password.isEmpty {
            self.showErrorTextField?(nil, ValidationError.emptyPassword.localizedDescription)
        } else {
            self.showErrorTextField?("", "")
        }
    }
    
    func fetchLoginApi(token: String, username: String, password: String){
        
        APIServices.shared.request(url: Constant.baseUrl + "3/authentication/token/validate_with_login?username=\(username)&password=\(password)&request_token=\(token)&api_key=\(Constant.apiKey)", method: .post, params: nil, encoding: JSONEncoding.default, headers: nil) { [weak self](_ login : LoginModel?, _ errorModel: BaseErrorModel?, error) in
            
            guard let self = self else { return }
            self.isLoading.value = false
                if let error = error {
                    self.showErrors(title: "Error", description: error.localizedDescription)
                } else if let errorModel = errorModel {
                    self.showErrors(title: "Error", description: errorModel.status_message ?? "")
                } else {
                if let result = login {
                    self.loginSucces.value = result
                }
            }
        }
    }
    
    func showErrors(title: String, description: String){
        let error = AlertError(title: title, description: description, action: AlertAction(title: "OK", handle: nil))
        self.showError.value = error
    }
}
