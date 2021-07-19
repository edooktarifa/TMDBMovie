//
//  UITextfield.swift
//  TMDBMovie
//
//  Created by Phincon on 13/07/21.
//

import Foundation
import UIKit

extension UITextField {
  func setLeftView(image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20)) // set your Own size
    iconView.image = image
    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    iconContainerView.addSubview(iconView)
    rightView = iconContainerView
    rightViewMode = .always
    self.tintColor = .lightGray
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    iconView.isUserInteractionEnabled = true
    iconView.addGestureRecognizer(tapGestureRecognizer)
  }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if isSecureTextEntry == true {
            isSecureTextEntry = false
            setLeftView(image: UIImage(named: "eye")!)
        } else {
            isSecureTextEntry = true
            setLeftView(image: UIImage(named: "invisible")!)
        }
    }
}
