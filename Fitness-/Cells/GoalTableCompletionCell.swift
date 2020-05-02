//
//  GoalTableCompletionCell.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/19/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class GoalTableCompletionCell: UITableViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    var goal: Goal.CompleteGoal!
    var table: UITableView!
    var home: HomeViewController!
    
    func setup() {
        completeButton.layer.cornerRadius = completeButton.frame.width/4
        completeButton.layer.borderWidth = 2
        layer.borderWidth = 2
        if goal.completionTime == "" {
            completeButton.layer.borderColor = constants.optimalGreen.cgColor
            let customTitle = NSAttributedString(string: "Done!",
            attributes: [NSAttributedString.Key.foregroundColor : constants.optimalGreen])
            completeButton.setAttributedTitle(customTitle, for: .normal)
            layer.borderColor = constants.optimalRed.cgColor
        } else {
            completeButton.layer.borderColor = constants.optimalRed.cgColor
            layer.borderColor = constants.optimalGreen.cgColor
           let customTitle = NSAttributedString(string: "Undo",
            attributes: [NSAttributedString.Key.foregroundColor : constants.optimalRed])
            completeButton.setAttributedTitle(customTitle, for: .normal)
        }
        layer.cornerRadius = 15
    }
    
    
    @IBAction func checkOff(_ sender: Any) {
        if goal.completionTime == ""{
            goal.completionTime = currentTime()
            completeButton.setTitleColor(constants.optimalGreen, for: .normal)
            completeButton.layer.borderColor = constants.optimalGreen.cgColor
            data.updateCurrentGoals()
        } else {
            completeButton.setTitleColor(constants.optimalRed, for: .normal)
            completeButton.layer.borderColor = constants.optimalRed.cgColor
            goal.completionTime = ""
            data.updateCurrentGoals()
        }
        table.reloadData()
        home.checkCompletion()
    }
}
