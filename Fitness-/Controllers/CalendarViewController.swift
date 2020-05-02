//
//  CalendarViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/5/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase
class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var dateDetails: UICollectionView!
    @IBOutlet weak var selectionDate: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var calendar: UICollectionView!
    var monthDays = [31,28,31,30,31,30,31,31,30,31,30,31]
    var selectedGoals: [Goal]! =  []
    
    var monthIndex: Int!
    var year: Int!
    var firstDay: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthIndex = currentMonth()-1
        year = currentYear()
        
        dateLabel.textColor = constants.suboptimalBlue
        dateLabel.text = "\(constants.calendar[monthIndex]) \(year!)"
        
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor.black.cgColor
        calendar.delegate = self
        calendar.dataSource = self
        dateDetails.delegate = self
        dateDetails.dataSource = self
        firstDay = weekday()
    }
    
    @IBAction func goBack(_ sender: Any) {
        if monthIndex == 0{
            monthIndex = 11
            year -= 1
        } else {
            monthIndex -= 1
        }
        dateLabel.text = "\(constants.calendar[monthIndex]) \(year!)"
        setup()
        firstDay = weekday()
    }
    
    @IBAction func goForward(_ sender: Any) {
        if monthIndex == 11 {
            monthIndex = 0
            year += 1
        } else {
            monthIndex += 1
        }
        dateLabel.text = "\(constants.calendar[monthIndex]) \(year!)"
        setup()
        firstDay = weekday()
    }
    
    func setup() {
        if monthIndex == 1 && year % 4 == 0 {
            monthDays[monthIndex] = 29
        } else if monthIndex == 1 {
            monthDays[monthIndex] = 28
        }
        data.checkCompletions(month: monthIndex+1, year: year, numDays: monthDays[monthIndex], calendar: calendar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
        selectedGoals.removeAll()
        selectionDate.text = ""
        dateDetails.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(selectedGoals)
        if collectionView == dateDetails {
            return selectedGoals.count
        }
        return monthDays[monthIndex] + firstDay
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendar {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath) as? CalendarCell {
                if indexPath.item < firstDay {
                    cell.backgroundColor = UIColor.white
                    cell.dayLabel.textColor = UIColor.lightGray
                    if monthIndex == 0 {
                        cell.dayLabel.text = "\(monthDays[11]-firstDay+indexPath.item+1)"
                    } else {
                        cell.dayLabel.text = "\(monthDays[monthIndex-1]-firstDay+indexPath.item+1)"
                    }
                    return cell
                }
                cell.dayLabel.text = "\(indexPath.item + 1-firstDay)"
                cell.layer.borderWidth = 1
                cell.dayLabel.textColor = UIColor.black
                if let complete = data.user!.userCompletions[indexPath.item + 1 - firstDay] {
                    cell.color(completed: complete)
                } else {
                    cell.backgroundColor = UIColor.white
                }
                return cell
            }
        } else if collectionView == dateDetails {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goal", for: indexPath) as? CompletionCell {
                let goal = selectedGoals[indexPath.item]
                switch goal.type{
                case "increment":
                    let incGoal = goal as! Goal.IncrementGoal
                    cell.goalName.text = incGoal.name
                    cell.goalProgress.text = "\(incGoal.current)/\(incGoal.goal) \(incGoal.unit)"
                    cell.setup(complete: incGoal.current >= incGoal.goal)
                
                    return cell
                case "completion":
                    let compGoal = goal as! Goal.CompleteGoal
                    cell.goalName.text = compGoal.name
                    cell.goalProgress.text = ""
                    cell.setup(complete: compGoal.completionTime != "")
                
                    return cell
                default:
                    return UICollectionViewCell()
                }
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath) as? CalendarCell {
            selectionDate.text = ""
            selectedGoals.removeAll()
            var monthString = "\(monthIndex+1)"
            if monthIndex+1 < 10 {
                monthString = "0\(monthIndex+1)"
            }
            let day = indexPath.item-firstDay+1
            var dayString = "\(day)"
            if day < 10 {
                dayString = "0\(day)"
            }
            getSelectedGoals(date: "\(monthString)-\(dayString)-\(year!)", day: day)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func weekday() -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = monthIndex + 1
        dateComponents.day = 1
        
        let userCalendar = Calendar.current // user calendar
        let firstDay = userCalendar.date(from: dateComponents)
        
        var startIndex = userCalendar.component(.weekday, from: firstDay!)
        return startIndex-1
    }
    
    func getSelectedGoals(date: String, day: Int){
        let dayRef = db.collection("users").document(data.user!.uid).collection("days").document(date)
        dayRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.selectedGoals.append(contentsOf: data.unwrapGoals(goals: document.data()!["goals"] as! [String]))
                self.selectionDate.text = "\(constants.calendar[self.monthIndex]) \(day), \(self.year!)"
            }
            self.dateDetails.reloadData()
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
