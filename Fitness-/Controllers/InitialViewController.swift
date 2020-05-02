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

    @IBOutlet weak var progressLabel: UILabel!
    var progressBar: CAShapeLayer! = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = constants.optimalBlue.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUser()
    }
    func checkUser(){
        if let user = Auth.auth().currentUser {
            data = FirestoreData(email: user.email ?? "", username: user.displayName!, uid: user.uid, origin: self)
        } else {
            performSegue(withIdentifier: "noUser", sender: self)
        }
    }
    
    func showProgress() {
        progressBar.path = UIBezierPath(roundedRect: CGRect(x: progressLabel.frame.origin.x, y: progressLabel.frame.origin.y, width: progressLabel.frame.width, height: progressLabel.frame.height), cornerRadius: 3).cgPath
        progressBar.strokeColor = constants.optimalGreen.cgColor
        progressBar.fillColor = UIColor.clear.cgColor
        progressBar.lineCap = .round
        
        view.layer.addSublayer(progressBar)
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
