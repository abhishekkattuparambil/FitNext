//
//  WorkoutCustomizationViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/17/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class WorkoutCustomizationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var workoutField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var exerciseTable: UITableView!
    var workoutPage: WorkoutViewController!
    var wktIndex: Int?
    var originalname: String!
    var exercises: [Exercise]!
    var changed: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addVerticalGradientLayer(topColor: constants.optimalBlue, bottomColor: constants.suboptimalBlue)
        
        workoutField.addUnderline(color: UIColor.white)
        
        continueButton.layer.cornerRadius = continueButton.frame.width/8
        continueButton.backgroundColor = constants.optimalBlue
        cancelButton.layer.cornerRadius = cancelButton.frame.width/8
        cancelButton.backgroundColor = constants.optimalBlue
        addButton.layer.cornerRadius = addButton.frame.width/10
        addButton.backgroundColor = constants.suboptimalBlue
        
        exerciseTable.layer.borderWidth = 2
        exerciseTable.layer.cornerRadius = 10
        exerciseTable.layer.borderColor = UIColor.white.cgColor
        
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        
        if let index = wktIndex {
            workoutField.text = data.user!.workouts[index].name
            let deleteString = NSAttributedString(string: "Delete", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            deleteButton.setAttributedTitle(deleteString, for: .normal)
            deleteButton.layer.cornerRadius = deleteButton.frame.width/8
        } else {
            deleteButton.removeFromSuperview()
        }
    
        continueButton.disable()
        changed = false
        workoutField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        
        workoutField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if changed && workoutField.text != nil && workoutField.text != ""{
            continueButton.enable()
        }
        exerciseTable.reloadData()
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeWorkout(_ sender: Any) {
        var name = workoutField.text!
        if(originalname != name && data.user!.workouts.map{$0.name}.contains(name)) {
            presentAlertViewController(title: "Workout with current name already exists", message: "Please delete the old workout or change the current workout's name")
            return
        }
        data.addWorkout(originalName: originalname, name: name, exercises: exercises)
        if let index = wktIndex {
            var currWorkout = data.user!.workouts[index]
            if data.user!.dailyGoals.map({$0.name}).contains(currWorkout.name) {
                for goal in data.user!.dailyGoals{
                    if goal.name == currWorkout.name {
                        goal.name = name
                        data.updateCurrentGoals()
                        break
                    }
                }
            }
            currWorkout.name = name
            currWorkout.exercises = exercises
        }
        workoutPage.viewWillAppear(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newExercise(_ sender: Any) {
        performSegue(withIdentifier: "createExercise", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return exercises.count
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as? ExerciseTableCell {
                let currExercise = exercises[indexPath.item]
                cell.exerciseLabel.text = currExercise.name
                cell.exerciseLabel.textColor = constants.suboptimalBlue
                cell.exerciseDescription.text = currExercise.descriptiveString()
                cell.exerciseDescription.textColor = UIColor.lightGray
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            return UITableViewCell()
            
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "createExercise", sender: indexPath.item)
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if (workoutField.text != nil && workoutField.text != "") {
            continueButton.enable()
        } else {
            continueButton.disable()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ExerciseCustomizationViewController {
            dest.customizePage = self
            if let sent = sender {
                dest.exerciseIndex = sent as! Int
            }
        }
    }
    
    @IBAction func deleteWorkout(_ sender: Any) {
        if let index = wktIndex {
            let currWorkout = data.user!.workouts[index]
            data.user!.dailyGoals.removeAll(where: {$0.name == currWorkout.name})
            data.user!.workouts.remove(at: index)
            data.deleteWorkout(name: originalname)
        }
        workoutPage.viewWillAppear(true)
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
