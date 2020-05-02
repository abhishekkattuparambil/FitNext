//
//  GoalTableIncrementCell.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/19/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class GoalTableIncrementCell: UITableViewCell {
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var percentage: UILabel!
    var goal: Goal.IncrementGoal!
    var table: UITableView!
    var progressBar: CAShapeLayer! = CAShapeLayer()
    var home: HomeViewController!
    
    @IBAction func addUnit(_ sender: Any) {
        goal.current += 1
        data.updateCurrentGoals()
        home.checkCompletion()
        table.reloadData()
    }
    
    @IBAction func subtractUnit(_ sender: Any) {
        if goal.current > 0 {
            goal.current -= 1
            data.updateCurrentGoals()
            home.checkCompletion()
            table.reloadData()
        }
    }
    
    func setup() {
        plusButton.layer.cornerRadius = plusButton.frame.width/2
        minusButton.layer.cornerRadius = minusButton.frame.width/2
        plusButton.layer.borderWidth = 2
        plusButton.layer.borderColor = constants.optimalGreen.cgColor
        minusButton.layer.borderWidth = 2
        minusButton.layer.borderColor = constants.optimalRed.cgColor
        plusButton.setTitleColor(constants.optimalGreen, for: .normal)
       let customTitle = NSAttributedString(string: "-",
                                                    attributes: [NSAttributedString.Key.foregroundColor : constants.optimalRed])
        minusButton.setAttributedTitle(customTitle, for: .normal)
        
        layer.borderWidth = 2
        if (goal.current >= goal.goal) {
            layer.borderColor = constants.optimalGreen.cgColor
        } else {
            layer.borderColor = constants.optimalRed.cgColor
        }
        layer.cornerRadius = 15
        
        percentage.layer.cornerRadius = percentage.frame.width/2
        percentage.layer.backgroundColor = UIColor.rgb(245,245,220).cgColor
        percentage.textColor = constants.optimalGreen
        
        drawProgress()
    }
    
    func drawProgress() {
        let progress = Double(goal.current)/Double(goal.goal)
        let percent = String(format:"%.4f", progress)
        let path = UIBezierPath(arcCenter: percentage.center, radius: percentage.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: (2*CGFloat.pi*CGFloat(progress))-CGFloat.pi/2, clockwise: true)
        progressBar.path = path.cgPath
        
        progressBar.strokeColor = constants.optimalGreen.cgColor
        progressBar.lineWidth = 4
        progressBar.fillColor = UIColor.clear.cgColor
        
        percentage.text = "\(percent.toDouble()!*100)%"
        progressBar.lineCap = .round
       //progressBar.strokeEnd = -CGFloat.pi/2
        
        layer.addSublayer(progressBar)
        
        //animate()
        
    }
    
    func animate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = CGFloat.pi
        animation.duration = 2
        
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        progressBar.add(animation, forKey: "progress")
    }
    
}
