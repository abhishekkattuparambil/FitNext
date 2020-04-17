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

    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
