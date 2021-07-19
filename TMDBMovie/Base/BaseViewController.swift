//
//  BaseViewController.swift
//  TMDBMovie
//
//  Created by Phincon on 13/07/21.
//

import UIKit
import SwiftMessages
import NVActivityIndicatorView

class BaseViewController: UIViewController {

    let loading = NVActivityIndicatorView(frame: .zero, type: .ballTrianglePath, color: UIColor.red)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLoading()
    }
    
    
    func showError(title: String, body: String){
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.error)
        warning.configureDropShadow()
        warning.button?.isHidden = true
        warning.configureContent(title: title, body: body)
        
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        warningConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    
    func showSucces(body: String){
        let succes = MessageView.viewFromNib(layout: .cardView)
        succes.configureTheme(.success)
        succes.configureDropShadow()
        succes.configureContent(title: "Succes", body: body)
        succes.button?.isHidden = true
        var succesConfig = SwiftMessages.defaultConfig
        succesConfig.presentationStyle = .center
        succesConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: succesConfig, view: succes)
    }
    
    func setupLoading(){
        self.loading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.loading)
        
        NSLayoutConstraint.activate([
            self.loading.widthAnchor.constraint(equalToConstant: 40),
            self.loading.heightAnchor.constraint(equalToConstant: 40),
            self.loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

}
