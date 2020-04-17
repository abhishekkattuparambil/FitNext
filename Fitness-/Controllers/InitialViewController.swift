//
//  InitialViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/14/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUser()
    }
    func checkUser(){
        if let user = Auth.auth().currentUser {
            data = FirestoreData(email: user.email ?? "", username: user.displayName!, uid: user.uid)
            performSegue(withIdentifier: "existingUser", sender: self)
        } else {
            performSegue(withIdentifier: "noUser", sender: self)
        }
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
