//
//  ViewController.swift
//  TMDBMovie
//
//  Created by Phincon on 11/07/21.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftMessages
import FirebaseCrashlytics

class LoginVC: BaseViewController {

    @IBOutlet weak var emailTf: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var passwordTf: SkyFloatingLabelTextFieldWithIcon!
    
    let vm = LoginViewModel()
    var token : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    func bindData(){
        self.loading.startAnimating()
        
        passwordTf.setLeftView(image: UIImage(named: "invisible")!)
        passwordTf.delegate = self
        emailTf.delegate = self
        
        vm.isLoading.bind { [unowned self](isLoading) in
            isLoading ? self.loading.startAnimating() : self.loading.stopAnimating()
        }
        
        vm.loginToken.bind { [weak self](loginData) in
            guard let self = self else { return }
            if let token = loginData?.request_token {
                self.token = token
            }
        }
        
        vm.showErrorTextField = {
            [weak self] (email, password) in
            guard let self = self else { return }
            self.emailTf.errorMessage = email
            self.passwordTf.errorMessage = password
        }

        vm.showError.bind { [weak self](error) in
            guard let self = self else { return }
//            let keysAndValues = [
//                                "title": error?.title ?? "",
//                                "description": error?.description ?? ""
//                            ] as [String : Any]
//
//            Crashlytics.crashlytics().setCustomKeysAndValues(keysAndValues)
//            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
            fatalError()
            self.showError(title: error?.title ?? "", body: error?.description ?? "")
        }
        
        vm.loginSucces.bind { [weak self](login) in
            guard let self = self else { return }
            let vc = TabBarVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        vm.fetchGetTokenApi()
    }
    
    @IBAction func loginAction(_ sender: UIButton){

        
        if let error = vm.validateInput(email: self.emailTf.text ?? "", password: self.passwordTf.text ?? ""){
            showError(title: "ERROR", body: error.localizedDescription)
        } else {
            loading.startAnimating()
            vm.fetchLoginApi(token: token, username: self.emailTf.text!, password: self.passwordTf.text!)
        }
    }
}

extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        vm.validateInputTextField(email: emailTf.text ?? "", password: passwordTf.text ?? "")
        view.endEditing(true)
        return true
    }
}
