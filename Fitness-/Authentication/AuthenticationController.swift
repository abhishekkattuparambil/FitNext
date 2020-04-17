//
//  Authentication Controller.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/7/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthenticationController: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
    
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    let loginButton: FBLoginButton = FBLoginButton()
    
    var googleColor = UIColor.rgb(220, 78, 65)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addVerticalGradientLayer(topColor: constants.topColor, bottomColor: constants.bottomColor)
        
        signUpButton.layer.cornerRadius = signUpButton.frame.width/25
        logInButton.layer.cornerRadius = logInButton.frame.width/25
        googleButton.layer.cornerRadius = googleButton.frame.width/25
        facebookButton.layer.cornerRadius = facebookButton.frame.width/25
        signUpButton.setTitleColor(constants.bottomColor, for: .normal)
        logInButton.setTitleColor(constants.bottomColor, for: .normal)
        emailField.addUnderline(color: UIColor.white)
        passwordField.addUnderline(color: UIColor.white)
        logInButton.disable()
        
        emailField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        
        googleButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(facebookSignIn), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        loginButton.delegate = self
        loginButton.permissions = ["email", "public_profile"]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    @objc func googleSignIn(){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func facebookSignIn(){
        loginButton.sendActions(for: .touchUpInside)
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if (emailField.text != nil && emailField.text != "" && passwordField.text != nil && passwordField.text != "") {
            logInButton.enable()
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                self.presentAlertViewController(title: error.localizedDescription, message: "Please fix the issue above")
                return
            }
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else {return }
            guard let username = result?.user.displayName else { return }
            data = FirestoreData(email: email, username: username, uid: uid)
            self.performSegue(withIdentifier: "signIn", sender: self)
        }
    }
    
    @objc func handleLogIn(){
        logIn(email: emailField.text!, password: passwordField.text!)
    }
    
    func logIn(email: String, password: String ){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.presentAlertViewController(title: error.localizedDescription, message: "Please try logging in again")
                return
            }
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else {return }
            guard let username = result?.user.displayName else { return }
            data = FirestoreData(email: email, username: username, uid: uid)
            self.performSegue(withIdentifier: "signIn", sender: self)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            self.presentAlertViewController(title: error.localizedDescription, message: "Please try logging in again")
            return
        }
        showEmail()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            self.presentAlertViewController(title: signOutError.localizedDescription, message: "Action cannot be completed")
        }
    }
    
    func showEmail(){
        let accessToken = AccessToken.current
        guard let accesTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accesTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if let error = error {
                self.presentAlertViewController(title: error.localizedDescription, message: "Please try signing in again")
            }
            self.performSegue(withIdentifier: "signIn", sender: self)
        }
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let user = result {
                let answer = user as! Dictionary<String, String>
                print(answer["id"]!)
                data = FirestoreData(email: answer["email"]!, username: answer["name"]!, uid: Auth.auth().currentUser!.uid)
            }
        }
    }
    
    static func handleLogOut() throws -> Void{
        let loginManager = LoginManager()
        loginManager.logOut()
        try! Auth.auth().signOut()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
