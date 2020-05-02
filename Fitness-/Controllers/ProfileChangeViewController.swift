//
//  ProfileChangeViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/30/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase
class ProfileChangeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var oldText: UILabel!
    @IBOutlet weak var newText: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var oldField: UITextField!
    @IBOutlet weak var newField: UITextField!
    @IBOutlet weak var popupView: UIView!
    var changed: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.layer.cornerRadius = continueButton.frame.width/8
        continueButton.backgroundColor = constants.suboptimalBlue
        continueButton.disable()
        cancelButton.backgroundColor = constants.suboptimalBlue
        cancelButton.layer.cornerRadius = cancelButton.frame.width/8
        
        oldField.addUnderline(color: constants.optimalBlue)
        newField.addUnderline(color: constants.optimalBlue)
        oldField.delegate = self
        newField.delegate = self
        
        oldField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        newField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = constants.optimalBlue.cgColor
        popupView.layer.borderWidth = 2
        popupView.backgroundColor = UIColor.white
            
        oldField.delegate = self
        newField.delegate = self
        
        if changed == "username" {
            oldField.text = data.user!.username
            oldField.isUserInteractionEnabled = false
            oldText.text = "Old Username"
            newText.text = "New Username"
        } else {
            oldText.text = "Old Password"
            newText.text = "New Password"
            oldField.disableAutoFill()
            newField.disableAutoFill()
            oldField.isSecureTextEntry = true
            newField.isSecureTextEntry = true
        }
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if oldField.text != nil && oldField.text != "" && newField.text != nil && newField.text != ""{
            continueButton.enable()
        } else {
            continueButton.disable()
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeProfile(_ sender: Any) {
        if changed == "password" {
            changePassword(email: data.user!.email, currentPassword: oldField.text!, newPassword: newField.text!)
        } else {
            data.user!.username = newField.text!
            data.updateUsername()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                self.presentAlertViewController(title: "Old password is incorrect", message: "Please enter correct password and retry")
                return
            }
            else {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        })
    }
}

