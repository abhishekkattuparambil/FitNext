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
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    var workoutPage: WorkoutViewController!
    var prIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = prIndex{
            nameTextField.text = data.user!.personalBests[index].exercise
            weightTextField.text =  String(data.user!.personalBests[index].weight)
            deleteButton.layer.cornerRadius = deleteButton.frame.width/8
        } else {
            heightConstraint.constant -= 70
            deleteButton.removeFromSuperview()
        }
        
        continueButton.layer.cornerRadius = continueButton.frame.width/8
        continueButton.backgroundColor = constants.suboptimalBlue
        continueButton.disable()
        cancelButton.backgroundColor = constants.suboptimalBlue
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
        
        nameTextField.delegate = self
        weightTextField.delegate = self
        
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if nameTextField.text != nil && nameTextField.text != "" && weightTextField.text != nil && weightTextField.text != "" && weightTextField.text!.isDouble(){
            continueButton.enable()
        } else {
            continueButton.disable()
        }
        
    }
    
    @IBAction func createBest(_ sender: Any) {
        if let index = prIndex{
            data.addBest(exercise: nameTextField.text!, weight: weightTextField.text!.toDouble()!, changed: index)
        } else {
            data.addBest(exercise: nameTextField.text!, weight: weightTextField.text!.toDouble()!, changed: -1)
        }
        workoutPage.viewWillAppear(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBest(_ sender: Any) {
        if let index = prIndex{
            data.user!.personalBests.remove(at: index)
            data.updateBests()
            workoutPage.viewWillAppear(true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
