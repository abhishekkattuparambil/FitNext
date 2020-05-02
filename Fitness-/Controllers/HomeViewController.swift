//
//  HomeViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/5/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var goalTable: UITableView!
    @IBOutlet weak var addGoal: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGoal.layer.cornerRadius = addGoal.frame.width/10
        addGoal.backgroundColor = constants.optimalGreen
        welcomeLabel.text = "Welcome, \(data.user!.username)!"
        // Do any additional setup after loading the view.
        goalTable.delegate = self
        goalTable.dataSource = self
        
        checkCompletion()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goalTable.reloadData()
        welcomeLabel.text = "Welcome, \(data.user!.username)!"
        checkCompletion()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var goal = data.user!.dailyGoals[indexPath.section]
        switch goal.type{
        case "increment":
            if let cell = tableView.dequeueReusableCell(withIdentifier: "incrementCell", for: indexPath) as? GoalTableIncrementCell {
                let incGoal = goal as! Goal.IncrementGoal
                cell.goalName.text = incGoal.name
                cell.progressLabel.text = "\(incGoal.current)/\(incGoal.goal) \(incGoal.unit)"
                cell.progressLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 0)
                cell.progressBar.removeFromSuperlayer()
                cell.table = goalTable
                cell.goal = incGoal
                cell.home = self
                cell.setup()
                
                return cell
            }
        case "completion":
            if let cell = tableView.dequeueReusableCell(withIdentifier: "completionCell", for: indexPath) as? GoalTableCompletionCell {
                let compGoal = goal as! Goal.CompleteGoal
                cell.table = goalTable
                cell.goal = compGoal
                cell.home = self
                cell.setup()
                cell.goalName.text = compGoal.name
                cell.progressLabel.text = compGoal.completionTime
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGoal", sender: indexPath.section)
    }
    
    @IBAction func newGoal(_ sender: Any) {
        performSegue(withIdentifier: "newGoal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        if let dest = segue.destination as? NewGoalViewController{
            dest.homePage = self
        }
        
        if let dest = segue.destination as? CustomGoalViewController{
            dest.goalIndex = sender as! Int
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.user!.dailyGoals.count
    }
    
    func checkCompletion() {
        data.user!.completed = true
        for goal in data.user!.dailyGoals {
            switch goal.type {
            case "increment":
                let incGoal = goal as! Goal.IncrementGoal
                if incGoal.current < incGoal.goal {
                    data.user!.completed = false
                    break;
                }
            default:
                let compGoal = goal as! Goal.CompleteGoal
                if compGoal.completionTime == "" {
                    data.user!.completed = false
                    break;
                }
            }
        }
        if data.user!.dailyGoals.count == 0 {
            data.user!.completed = false
        }
        data.updateCompletions()
        if (data.user!.completed) {
            completionLabel.text = "Today's Goals: Completed!"
        } else {
            completionLabel.text = "Today's Goals:"
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
