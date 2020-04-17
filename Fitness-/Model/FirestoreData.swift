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
    let username: String
    let uid: String
    var workouts: [Workout]
    var dailyGoals: [String:[Goal]]
    var personalBests: [PersonalBest]
    
    init(email: String, username: String, uid: String) {
        self.email = email
        self.username = username
        self.uid = uid
        self.workouts = []
        self.personalBests = []
        self.dailyGoals = [:]
    }
}

class FirestoreData {
    var user: User?
    init(email: String, username: String, uid: String){
        user = User(email: email, username: username, uid: uid)
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                self.user!.workouts = dataDescription!["workouts"]! as! [Workout]
                self.unwrapBests(bests: dataDescription!["personal bests"] as! [String])
                self.user!.dailyGoals = dataDescription!["Daily Goals"]! as! [String:[Goal]]
            } else {
                self.addUser(email: email, username: username, uid: uid)
                self.user!.personalBests = [PersonalBest(exercise: "Bench Press", weight: 0), PersonalBest(exercise: "Squat", weight: 0), PersonalBest(exercise: "Deadlift", weight: 0)]
            }
        }
    }
    
    
    func addUser(email: String, username: String, uid: String) {
        db.collection("users").document(uid).setData([
            "email": email,
            "username": username,
            "uid": uid,
            "workouts": [],
            "personal bests": ["Bench Press,0.0", "Squat,0.0", "Deadlift,0.0"],
            "Daily Goals": [:]
        ]) { (err) in
            if let err = err{
                print("Error adding document: \(err)")
            } else {
                print("Document added with reference ID: \(uid)")
            }
        }
    }
    
    func addWorkout(name: String, exercises: [Exercise]){
        
    }
    
    func addBest(exercise: String, weight: Double){
        user!.personalBests.append(PersonalBest(exercise: exercise, weight: weight))
        db.collection("users").document(user!.uid).updateData([
            "personal bests": self.user!.personalBests.map{$0.toString()}
        ])
    }
    
    func userLeft(){
        user = nil
    }
    
    func unwrapBests(bests: [String]){
        for best in bests{
            var splits = best.split(separator: ",").map{String($0)}
            self.user!.personalBests.append(PersonalBest(exercise: splits[0], weight: splits[1].toDouble()!))
        }
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
    
    init(goalName: String){
        self.name = goalName
    }
    
    class CompleteGoal: Goal{
        
    }
    
    class IncrementGoal: Goal{
        var current: Int
        var goal: Int
        
        init(name: String, current: Int, goal: Int){
            self.current = current
            self.goal = goal
            super.init(goalName: name)
        }
    }
}
