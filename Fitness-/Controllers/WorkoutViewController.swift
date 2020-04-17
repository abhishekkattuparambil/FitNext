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
            
            switch pr.exercise {
            case "Deadlift":
                cell.exerciseImage.image = constants.deadlift
            case "Squat":
                cell.exerciseImage.image = constants.squat
            case "Bench Press":
                cell.exerciseImage.image = constants.bench
            default:
                cell.exerciseImage.image = constants.dumbbell
                
            }
            
            cell.layer.borderColor = constants.CGoptimalBlue
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            
            
            return cell
        } else {
            return UICollectionViewCell()
        }
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
            cell.workoutButton.setTitle(currWorkout.name, for: .normal)
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func newWorkout(_ sender: Any) {
        var cap: [Exercise] = [Exercise(name: "Overhead Bar Press", sets: 4, reps: 10, weight: 70), Exercise(name: "Dumbbell Press", sets: 4, reps: 12, weight: 35)]
        data.addWorkout(name: "Shoulder Shambler", exercises: cap)
        //data.addWorkout(name: "Bicep Blaster", sets: 4, reps: 12, weight: 60)
        workoutTable.reloadData()
    }
    
    @IBAction func newPersonalBest(_ sender: Any) {
        performSegue(withIdentifier: "newBest", sender: self)
        prCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PRViewController {
            dest.workoutPage = self
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
