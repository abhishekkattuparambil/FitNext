//
//  CustomGoalViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/20/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase

class CustomGoalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var currentField: UITextField!
    @IBOutlet weak var goalField: UITextField!
    @IBOutlet weak var unitField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var incStack: UIStackView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var clearTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var yesterdayLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    var goalIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: constants.optimalGreen, bottomColor: constants.optimalBlue)
        
        goalField.addUnderline(color: UIColor.white)
        nameField.addUnderline(color: UIColor.white)
        currentField.addUnderline(color: UIColor.white)
        unitField.addUnderline(color: UIColor.white)
        
        continueButton.layer.cornerRadius = continueButton.frame.width/8
        continueButton.backgroundColor = constants.suboptimalBlue
        continueButton.disable()
        cancelButton.backgroundColor = constants.suboptimalBlue
        cancelButton.layer.cornerRadius = cancelButton.frame.width/8
        clearButton.backgroundColor = constants.optimalBlue
        clearButton.layer.cornerRadius = clearButton.frame.width/7
        
        unitField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        nameField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        currentField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        goalField.addTarget(self, action: #selector(fieldsFilled), for: .editingChanged)
        
        if let index  = goalIndex{
            deleteButton.layer.cornerRadius = deleteButton.frame.width/8
            table.removeFromSuperview()
            orLabel.removeFromSuperview()
            yesterdayLabel.removeFromSuperview()
            topConstraint.constant = 85
            let currGoal = data.user!.dailyGoals[index]
            nameField.text = currGoal.name
            switch currGoal.type{
            case "increment":
                let incGoal = currGoal as! Goal.IncrementGoal
                unitField.text = incGoal.unit
                currentField.text = "\(incGoal.current)"
                goalField.text = "\(incGoal.goal)"
            default:
                incStack.removeFromSuperview()
                clearTopConstraint.constant = 40
            }
        } else {
            deleteButton.removeFromSuperview()
        }
        
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 15
        
        goalField.delegate = self
        nameField.delegate = self
        unitField.delegate = self
        currentField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //table.reloadData()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func fieldsFilled(_ target:UITextField) {
        if nameField.text != nil && nameField.text != "" && goalField.text != nil && goalField.text != "" && goalField.text!.isDouble() && currentField.text != nil && currentField.text != "" && currentField.text!.isDouble() && unitField.text != nil && unitField.text != ""{
            continueButton.enable()
        } else {
            continueButton.disable()
        }
    }
    
    @IBAction func createGoal(_ sender: Any) {
        if let index = goalIndex {
            let curr = data.user!.dailyGoals[index]
            switch curr.type {
            case "increment":
                data.user!.dailyGoals[index] = Goal.IncrementGoal(name: nameField.text!, current: currentField.text!.toInt()!, goal: goalField.text!.toInt()!, unit: unitField.text!)
            default:
                data.user!.dailyGoals[index] = Goal.CompleteGoal(name: nameField.text!, completionTime: (curr as! Goal.CompleteGoal).completionTime)
            }
        } else {
            if data.user!.dailyGoals.map({$0.name}).contains(nameField.text!){
                presentAlertViewController(title: "Goal with this name already exists", message: "Please create a new goal or exit")
                return
            }
            data.user!.dailyGoals.append(Goal.IncrementGoal(name: nameField.text!, current: currentField.text!.toInt()!, goal: goalField.text!.toInt()!, unit: unitField.text!))
        }
        data.updateCurrentGoals()
        performSegue(withIdentifier: "backHome", sender: nil)
    }
    
    @IBAction func remove(_ sender: Any) {
        data.user!.dailyGoals.remove(at: goalIndex)
        data.updateCurrentGoals()
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.user!.prevGoals.count == 0 {
            table.removeFromSuperview()
            yesterdayLabel.removeFromSuperview()
            orLabel.removeFromSuperview()
            topConstraint.constant = 85
        }
        return data.user!.prevGoals.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "workoutName", for: indexPath) as? GoalTableWorkoutCell {
            let goal = data.user!.prevGoals[indexPath.item]
            cell.workoutName.text = goal.name
            cell.workoutName.textColor = constants.suboptimalBlue
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        continueButton.enable()
        let goal = data.user!.prevGoals[indexPath.item] as! Goal.IncrementGoal
        unitField.text = goal.unit
        goalField.text = "\(goal.goal)"
        nameField.text = goal.name
        currentField.text = "0"
    }
    
    @IBAction func clear(_ sender: Any) {
        if let index  = goalIndex{
            let currGoal = data.user!.dailyGoals[index]
            switch currGoal.type{
            case "increment":
                nameField.text = ""
                currentField.text = ""
                goalField.text = ""
                unitField.text = ""
            default:
                nameField.text = ""
            
            }
        } else {
            nameField.text = ""
            currentField.text = ""
            goalField.text = ""
            unitField.text = ""
        }
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
