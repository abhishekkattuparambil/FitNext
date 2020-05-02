//
//  FirestoreData.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/15/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit
import Firebase

var data: FirestoreData!
let db = Firestore.firestore()
class User {
    let email: String
    var username: String
    let uid: String
    var workouts: [Workout]
    var dailyGoals: [Goal]
    var personalBests: [PersonalBest]
    var prevGoals: [Goal]
    var userCompletions: [Int:Bool]
    var completed: Bool
    
    init(email: String, username: String, uid: String) {
        self.email = email
        self.username = username
        self.uid = uid
        self.workouts = []
        self.personalBests = []
        self.dailyGoals = []
        self.prevGoals = []
        self.userCompletions = [:]
        self.completed = false
    }
}

class FirestoreData {
    var user: User?
    init(email: String, username: String, uid: String, origin: UIViewController) {
        user = User(email: email, username: username, uid: uid)
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.unwrapBests(bests: document.data()!["personal bests"] as! [String])
                self.getPreviousGoals(date: getDate(date: getPreviousDate(days: 1)))
                self.user!.username = document.data()!["username"] as! String
                let workoutRef = userRef.collection("workouts")
                workoutRef.getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.user!.workouts.append(Workout(name: document.data()["name"] as! String, exercises: self.unwrapExercises(exercises: document.data()["exercises"] as! [String])))
                        }
                    }
                }
                let goalRef = userRef.collection("days").document(currentDate())
                goalRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        self.user!.dailyGoals = self.unwrapGoals(goals: document.data()!["goals"] as! [String])
                        self.user!.completed = document.data()!["completed"] as! Bool
                    }
                    if let sender = origin as? InitialViewController {
                        sender.performSegue(withIdentifier: "existingUser", sender: sender)
                    } else if let sender = origin as? AuthenticationController {
                        sender.performSegue(withIdentifier: "signIn", sender: sender)
                    } else if let sender = origin as? EmailSignUpController {
                        sender.performSegue(withIdentifier: "createAccount", sender: sender)
                    }
                }
            } else {
                self.addUser(email: email, username: username, uid: uid)
                self.user!.personalBests = [PersonalBest(exercise: "Bench Press", weight: 0), PersonalBest(exercise: "Squat", weight: 0), PersonalBest(exercise: "Deadlift", weight: 0)]
                if let sender = origin as? InitialViewController {
                    sender.performSegue(withIdentifier: "existingUser", sender: sender)
                } else if let sender = origin as? AuthenticationController {
                    sender.performSegue(withIdentifier: "signIn", sender: sender)
                } else if let sender = origin as? EmailSignUpController {
                    sender.performSegue(withIdentifier: "createAccount", sender: sender)
                }
            }
        }
    }
    
    
    func addUser(email: String, username: String, uid: String) {
        db.collection("users").document(uid).setData([
            "email": email,
            "username": username,
            "uid": uid,
            "personal bests": ["Bench Press,0.0", "Squat,0.0", "Deadlift,0.0"],
           // "previous goals": []
        ]) { (err) in
            if let err = err{
                print("Error adding document: \(err)")
            } else {
                print("Document added with reference ID: \(uid)")
            }
        }
    }
    
    func setWorkout(name: String, exercises: [Exercise]){
        db.collection("users").document(user!.uid).collection("workouts").document(name).setData([
            "name": name,
            "exercises": exercises.map{$0.toString()}
        ]) { (err) in
            if let err = err{
                print("Error adding document: \(err)")
            } else {
                print("Document added with reference ID: \(name)")
            }
        }
    }
    
    func addWorkout(originalName: String, name: String, exercises: [Exercise]){
        if originalName != "" {
            let docRef = db.collection("users").document(user!.uid).collection("workouts")
            docRef.document(originalName).delete()
        } else {
            user!.workouts.append(Workout(name: name, exercises: exercises))
        }
        setWorkout(name: name, exercises: exercises)
    }
    
    func deleteWorkout(name: String){
        db.collection("users").document(user!.uid).collection("workouts").document(name).delete()
    }
    
    func addBest(exercise: String, weight: Double, changed: Int){
        if(changed < 0) {
        user!.personalBests.append(PersonalBest(exercise: exercise, weight: weight))
        } else {
            user!.personalBests[changed] = PersonalBest(exercise: exercise, weight: weight)
        }
        updateBests()
    }
    
    func updateBests(){
        db.collection("users").document(user!.uid).updateData([
            "personal bests": self.user!.personalBests.map{$0.toString()}
            ])
    }
    
    func updateCurrentGoals(){
        db.collection("users").document(user!.uid).collection("days").document(currentDate()).setData([
            "goals": user!.dailyGoals.map{$0.toString()},
            "completed": user!.completed
        ])
    }
    
    func userLeft(){
        user = nil
    }
    
    func unwrapBests(bests: [String]){
        for best in bests{
            let splits = best.split(separator: ",").map{String($0)}
            self.user!.personalBests.append(PersonalBest(exercise: splits[0], weight: splits[1].toDouble()!))
        }
    }
    
    func unwrapExercises(exercises: [String]) -> [Exercise] {
        var result: [Exercise] = []
        for exercise in exercises {
            let splits = exercise.split(separator: ",").map{String($0)}
            result.append(Exercise(name: splits[0], sets: Int(splits[1])!, reps: Int(splits[2])!, weight: splits[3].toDouble()!))
        }
        return result
    }
    
    func unwrapGoals(goals: [String]) -> [Goal] {
        var result: [Goal] = []
        for goal in goals {
            let splits = goal.split(separator: ",").map{String($0)}
            switch splits[0]{
            case "increment":
                result.append(Goal.IncrementGoal(name: splits[1], current: Int(splits[2])!, goal: Int(splits[3])!, unit: splits[4]))
            default:
                if splits.count == 3 {
                    result.append(Goal.CompleteGoal(name: splits[1], completionTime: splits[2]))
                } else {
                    result.append(Goal.CompleteGoal(name: splits[1]))
                }
            }
        }
        return result
    }
    
    func getPreviousGoals(date: String){
        let dayRef = db.collection("users").document(user!.uid).collection("days").document(date)
        dayRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.user!.prevGoals.append(contentsOf: self.unwrapGoals(goals: document.data()!["goals"] as! [String]).filter({$0.type == "increment"}))
            }
        }
    }
    
    func checkCompletions(month: Int, year: Int, numDays: Int, calendar: UICollectionView){
        user!.userCompletions.removeAll()
        var monthString = "\(month)"
        if month < 10 {
            monthString = "0\(month)"
        }
        let daysRef = db.collection("users").document(user!.uid).collection("days")
        for i in 1..<numDays+1 {
            var dayString = "\(i)"
            user!.userCompletions[i] = nil
            if i < 10 {
                dayString = "0\(i)"
            }
            daysRef.document("\(monthString)-\(dayString)-\(year)").getDocument { (document, error) in
                if let document = document, document.exists {
                    self.user!.userCompletions[i] = (document.data()!["completed"] as! Bool)
                }
                calendar.reloadData()
            }
        }
    }
    
    func updateCompletions() {
        db.collection("users").document(user!.uid).collection("days").document(currentDate()).updateData([
            "completed": user!.completed
        ])
    }
    
    func updateUsername(){
        db.collection("users").document(user!.uid).updateData([
            "username": self.user!.username
            ])
    }
}

class Workout{
    var name: String
    var exercises: [Exercise]
    
    init(name: String, exercises: [Exercise]) {
        self.name = name
        self.exercises = exercises
    }
}

class Exercise{
    var sets: Int
    var reps: Int
    var weight: Double
    var name: String
    
    init(name: String, sets: Int, reps: Int, weight: Double) {
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.name = name
    }
    
    func toString() -> String {
        return "\(name),\(sets),\(reps),\(weight)"
    }
    
    func descriptiveString() -> String {
        return "Sets: \(sets), Reps: \(reps), Weight: \(weight)"
    }
}

class PersonalBest{
    var exercise: String
    var weight: Double
    
    init(exercise: String, weight: Double) {
        self.exercise = exercise
        self.weight = weight
    }
    
    func toString() -> String{
        return "\(self.exercise),\(self.weight)"
    }
}

class Goal{
    var name: String
    var type: String
    
    init(goalName: String, type: String){
        self.name = goalName
        self.type = type
    }
        
    func toString() -> String {
        return ""
    }
    
    class CompleteGoal: Goal{
        var completionTime: String
        
        init(name: String, completionTime: String = "") {
            self.completionTime = completionTime
            super.init(goalName: name, type: "completion")
        }
        
        override func toString() -> String {
            return "completion,\(name),\(completionTime)"
        }
    }
    
    class IncrementGoal: Goal{
        var current: Int
        var goal: Int
        var unit: String
        
        init(name: String, current: Int, goal: Int, unit: String){
            self.current = current
            self.goal = goal
            self.unit = unit
            super.init(goalName: name, type: "increment")
        }
        
        override func toString() -> String {
            return "increment,\(name),\(current),\(goal),\(unit)"
        }
    }
}
