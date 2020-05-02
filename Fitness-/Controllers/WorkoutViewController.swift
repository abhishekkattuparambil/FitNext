//
//  WorkoutViewController.swift
//  Fitness +
//
//  Created by Abhishek Kattuparambil on 4/5/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var addBest: UIButton!
    @IBOutlet weak var addWorkout: UIButton!
    @IBOutlet weak var workoutTable: UITableView!
    @IBOutlet weak var prCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBest.layer.cornerRadius = addBest.frame.width/10
        addWorkout.layer.cornerRadius = addWorkout.frame.width/10
        addWorkout.backgroundColor = constants.optimalBlue
        addBest.backgroundColor = constants.optimalBlue
        
        workoutTable.delegate = self
        workoutTable.dataSource = self
        prCollection.delegate = self
        prCollection.dataSource = self
        
        workoutTable.layer.borderWidth = 2
        workoutTable.layer.cornerRadius = 10
        workoutTable.layer.borderColor = constants.optimalBlue.cgColor
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        workoutTable.reloadData()
        prCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.user!.personalBests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "prCell", for: indexPath) as? PersonalBestCollectionCell {
            let pr = data.user!.personalBests[indexPath.item]
            cell.exerciseName.text = pr.exercise
            if (pr.weight == 0) {
                cell.weight.text = "─"
            } else if (floor(pr.weight) == pr.weight){
                cell.weight.text = "\(Int(pr.weight))"
            } else {
                cell.weight.text = "\(pr.weight)"
            }
            cell.weight.textColor = constants.suboptimalBlue
            cell.exerciseName.textColor = constants.suboptimalBlue
            
            if pr.exercise.containsIgnoringCase(find: "Deadlift"){
                cell.exerciseImage.image = constants.deadlift
            } else if pr.exercise.containsIgnoringCase(find: "Squat"){
                cell.exerciseImage.image = constants.squat
            } else if pr.exercise.containsIgnoringCase(find: "Bench"){
                cell.exerciseImage.image = constants.bench
            } else {
                cell.exerciseImage.image = constants.dumbbell
            }
                
            
            cell.layer.borderColor = constants.optimalBlue.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // segue to preview controller with selected thread
        performSegue(withIdentifier: "newBest", sender: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
       {
          return CGSize(width: 105.0, height: 128.0)
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.user!.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutTableCell {
            let currWorkout = data.user!.workouts[indexPath.row]
            cell.workoutLabel.text = currWorkout.name
            cell.workoutLabel.textColor = constants.suboptimalBlue
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "createWorkout", sender: indexPath.item)
    }
    
    @IBAction func newWorkout(_ sender: Any) {
        performSegue(withIdentifier: "createWorkout", sender: nil)
        //data.addWorkout(name: "Bicep Blaster", sets: 4, reps: 12, weight: 60)
        workoutTable.reloadData()
    }
    
    @IBAction func newPersonalBest(_ sender: Any) {
        performSegue(withIdentifier: "newBest", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        if let dest = segue.destination as? PRViewController {
            dest.workoutPage = self
            dest.modalPresentationStyle = .overCurrentContext
            if let sent = sender{
                dest.prIndex = sent as! Int
            }
        }
        
        if let dest = segue.destination as? WorkoutCustomizationViewController {
            dest.workoutPage = self
            if let sent = sender{
                dest.wktIndex = sent as! Int
                dest.exercises = data.user!.workouts[sent as! Int].exercises
                dest.originalname = data.user!.workouts[sent as! Int].name
            } else {
                dest.exercises = []
                dest.originalname = ""
            }
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
