//
//  PRViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/17/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class PRViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    var workoutPage: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.layer.cornerRadius = continueButton.frame.width/8
        continueButton.disable()
        cancelButton.backgroundColor = constants.subOptimalBlue
        cancelButton.layer.cornerRadius = cancelButton.frame.width/8
        
        nameTextField.addUnderline(color: constants.optimalBlue)
        weightTextField.addUnderline(color: constants.optimalBlue)
        nameTextField.delegate = self
        weightTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        weightTextField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = constants.optimalBlue.cgColor
        popupView.layer.borderWidth = 2
        popupView.backgroundColor = UIColor.white
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if nameTextField.text != nil && nameTextField.text != "" && weightTextField.text != nil && weightTextField.text != "" && weightTextField.text!.isDouble(){
            continueButton.enable()
        } else {
            continueButton.disable()
        }
        
    }
    
    @IBAction func createBest(_ sender: Any) {
        data.addBest(exercise: nameTextField.text!, weight: weightTextField.text!.toDouble()!)
        workoutPage.viewWillAppear(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
