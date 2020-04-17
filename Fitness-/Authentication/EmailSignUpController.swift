//
//  EmailSignUp.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/6/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase

class EmailSignUpController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var showPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = createButton.frame.width/8
        createButton.setTitleColor(constants.bottomColor, for: .normal)
        createButton.setTitle("Create", for: .normal)
        createButton.disable()
        
        view.addVerticalGradientLayer(topColor: constants.topColor, bottomColor: constants.bottomColor)
        
        usernameField.addUnderline(color: UIColor.white)
        emailField.addUnderline(color: UIColor.white)
        passwordField.addUnderline(color: UIColor.white)
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        passwordField.disableAutoFill()
        
        usernameField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        emailField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showPassword(_ sender: Any) {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry;
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if (usernameField.text != nil && usernameField.text != "" && emailField.text != nil && emailField.text != "" && passwordField.text != nil && passwordField.text != "") {
            createButton.enable()
        } else {
            createButton.disable()
        }
        
    }
    
    @IBAction func createUser(_ sender: Any) {
        guard let username = usernameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        
        createButton.disable()
        createButton.setTitle("Loading...", for: .normal)
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil && checkUsername(username){
                print("User created!")
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        let currUser = Auth.auth().currentUser!
                        data = FirestoreData(email: currUser.email!, username: currUser.displayName!, uid: currUser.uid)
                        print("User display name changed!")
                        self.performSegue(withIdentifier: "createAccount", sender: self.createButton)
                    } else {
                        self.createButton.setTitle("Create", for: .normal)
                        self.presentAlertViewController(title: error!.localizedDescription, message: "Please refill the form")
                    }
                }
                
            } else {
                self.createButton.setTitle("Create", for: .normal)
                if (username == "") {
                    self.presentAlertViewController(title: "A username must be provided", message: "Please refill the form")
                } else if !checkUsername(username){
                    self.presentAlertViewController(title: "Username contains invalid characters", message: "Please refill the form")
                } else {
                    self.presentAlertViewController(title: error!.localizedDescription, message: "Please refill the form")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
