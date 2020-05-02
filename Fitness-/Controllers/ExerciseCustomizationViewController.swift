//
//  ExerciseCutomizationViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/18/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class ExerciseCustomizationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var repField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var setField: UITextField!
    var exerciseIndex: Int?
    var customizePage: WorkoutCustomizationViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addVerticalGradientLayer(topColor: constants.optimalBlue, bottomColor: constants.suboptimalBlue)
        nameField.addUnderline(color: UIColor.white)
        setField.addUnderline(color: UIColor.white)
        repField.addUnderline(color: UIColor.white)
        weightField.addUnderline(color: UIColor.white)
        
        continueButton.layer.cornerRadius = continueButton.frame.width/8
        continueButton.backgroundColor = constants.optimalBlue
        cancelButton.layer.cornerRadius = cancelButton.frame.width/8
        cancelButton.backgroundColor = constants.optimalBlue
        
        setField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        repField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        nameField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        weightField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        
        if let index = exerciseIndex {
            nameField.text = customizePage.exercises[index].name
            setField.text = String(customizePage.exercises[index].sets)
            repField.text = String(customizePage.exercises[index].reps)
            weightField.text = String(customizePage.exercises[index].weight)
            deleteButton.layer.cornerRadius = deleteButton.frame.width/8
        } else {
            deleteButton.removeFromSuperview()
        }
        continueButton.disable()
        
        nameField.delegate = self
        setField.delegate = self
        repField.delegate = self
        weightField.delegate = self
        
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if (repField.text != nil && repField.text != "" && nameField.text != nil && nameField.text != "" && weightField.text != nil && weightField.text != "" && setField.text != nil && setField.text != "" && setField.text!.isInt() && repField.text!.isInt() && weightField.text!.isDouble()) {
            continueButton.enable()
        } else {
            continueButton.disable()
        }
        
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeExercise(_ sender: Any) {
        if let index = exerciseIndex {
            customizePage.exercises[index] = Exercise(name: nameField.text!, sets: Int(setField.text!)!, reps: Int(repField.text!)!, weight: Double(weightField.text!)!)
        } else {
            customizePage.exercises.append(Exercise(name: nameField.text!, sets: Int(setField.text!)!, reps: Int(repField.text!)!, weight: Double(weightField.text!)!))
        }
        customizePage.changed = true
        customizePage.viewWillAppear(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteExercise(_ sender: Any) {
        if let index = exerciseIndex {
            customizePage.exercises.remove(at: index)
        }
        customizePage.changed = true
        customizePage.viewWillAppear(true)
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
