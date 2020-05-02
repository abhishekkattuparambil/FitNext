//
//  SettingsViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/5/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIActionSheetDelegate {
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordButton.backgroundColor = constants.optimalBlue
        passwordButton.layer.cornerRadius = 30
        usernameButton.backgroundColor = constants.optimalBlue
        usernameButton.layer.cornerRadius = 30
        signOutButton.backgroundColor = constants.suboptimalBlue
        signOutButton.layer.cornerRadius = 20
        logoutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)

        if Auth.auth().currentUser!.providerData[0].providerID != "password" {
            passwordButton.removeFromSuperview()
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        if let dest = segue.destination as? ProfileChangeViewController {
            dest.changed = sender as! String
            dest.modalPresentationStyle = .overCurrentContext
        }
    }
    
    @objc func signOut(){
        let signOutHandler = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            do {
                try AuthenticationController.handleLogOut()
                data.userLeft()
                self.performSegue(withIdentifier: "Sign Out", sender: self)
                
            } catch let err {
                self.presentAlertViewController(title: "Failed to Sign Out", message: err.localizedDescription)
            }
        }
        let cancelHandler = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(signOutHandler)
        actionSheet.addAction(cancelHandler)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
        performSegue(withIdentifier: "changeProfile", sender: "password")
    }
    
    
    @IBAction func changeUsername(_ sender: Any) {
        performSegue(withIdentifier: "changeProfile", sender: "username")
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
