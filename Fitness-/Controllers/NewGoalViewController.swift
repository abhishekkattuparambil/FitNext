//
//  GoalCustomizationViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/20/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class NewGoalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var workoutTable: UITableView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var customGoal: UIButton!
    @IBOutlet weak var addWorkoutGoal: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var homePage: HomeViewController!
    var workout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addVerticalGradientLayer(topColor: constants.optimalGreen, bottomColor: constants.optimalBlue)
        
        workoutTable.delegate = self
        workoutTable.dataSource = self
        workoutTable.layer.cornerRadius = 15

        confirmationLabel.text = ""
        
        customGoal.layer.cornerRadius = customGoal.frame.width/9
        addWorkoutGoal.layer.cornerRadius = addWorkoutGoal.frame.width/9
        cancelButton.layer.cornerRadius = cancelButton.frame.width/5
        customGoal.backgroundColor = UIColor.white
        cancelButton.backgroundColor = UIColor.white
        addWorkoutGoal.backgroundColor = UIColor.white
        let customTitle = NSAttributedString(string: "Create Custom Goal",
                                             attributes: [NSAttributedString.Key.foregroundColor : constants.optimalGreen])
        customGoal.setAttributedTitle(customTitle, for: .normal)
        let workoutTitle = NSAttributedString(string: "Add Workout Goal",
                                                    attributes: [NSAttributedString.Key.foregroundColor : constants.optimalBlue])
        addWorkoutGoal.setAttributedTitle(workoutTitle, for: .normal)
        let cancelTitle = NSAttributedString(string: "Cancel",
                                                    attributes: [NSAttributedString.Key.foregroundColor : constants.suboptimalBlue])
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        addWorkoutGoal.disable()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.user!.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "workoutName", for: indexPath) as? GoalTableWorkoutCell {
            let workout = data.user!.workouts[indexPath.item]
            cell.workoutName.text = workout.name
            cell.workoutName.textColor = constants.suboptimalBlue
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workout = data.user!.workouts[indexPath.item]
        confirmationLabel.text = "Would you like to add the workout \(workout!.name) today?"
        addWorkoutGoal.enable()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addWorkout(_ sender: Any) {
        if data.user!.dailyGoals.map({$0.name}).contains(workout!.name){
            self.presentAlertViewController(title: "This workout is already a goal for today", message: "Please add a different goal or exit")
            return
        }
        data.user!.dailyGoals.append(Goal.CompleteGoal(name: workout!.name))
        data.updateCurrentGoals()
        homePage.viewWillAppear(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func customGoal(_ sender: Any) {
        performSegue(withIdentifier: "customGoal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
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
