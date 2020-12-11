//
//  goalsViewController.swift
//  travelApp
//
//  Created by Fedor Korshikov on 09.04.2020.
//  Copyright © 2020 Fedor Korshikov. All rights reserved.
//

import UIKit
import Foundation
import SwiftKeychainWrapper
import SwiftyJSON

class ShowAllGoalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GoalsViewControllerDelegate
{
    func cellCheckedUnchecked(checked: Bool, indexPath: IndexPath) {
        let goal = goals[indexPath.item]
        Goal.editGoal(goal: goal, name: goal.name!, isDone: checked, descript: "")
        update()
        return
    }
    
    
    func update() {
        goals = trip?.triptogoal?.allObjects as? [Goal] ?? [Goal]()
        sortGoals()
        collectionView.reloadData()
        
    }
    
    func sortGoals() {
           goals.sort(by: {
            return !$0.isDone && $1.isDone
           })
       }
    
    
    
    var tripId: String?
    var goals = [Goal] ()
    var trip: Trip?
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let strb = UIStoryboard(name: "Main", bundle: nil)
        let addGoalVC = strb.instantiateViewController(withIdentifier: "addGoalVC") as! AddGoalViewController
        
        addGoalVC.editMode = false
        addGoalVC.trip = trip
        addGoalVC.delegate = self
        
        self.present(addGoalVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        update()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
    collectionView.addGestureRecognizer(longPressGesture)
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goalsCell", for: indexPath as! IndexPath) as! GoalCollectionViewCell
        cell.setupDesign()
        if goals.count <= indexPath.item { print ("incorrect invocation of a cell");  return cell }
        var goal = goals[indexPath.item]
        cell.setFields(name: goal.name!, desc: goal.descript!, checkedImage: UIImage(named:"pressed-rb.png"), uncheckedImage: UIImage(named:"notPressedRb.png"), checked: goal.isDone, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("!!!")
        print (indexPath.item)
        print (goals.count)
        return
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // getTrip()
        collectionView.reloadData()
    }
    
    
    
    func reloadCollectionViewData(){
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    
    
    
 
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
           if gesture.state != .ended {
               return
           }

           let p = gesture.location(in: self.collectionView)

           if let indexPath = self.collectionView.indexPathForItem(at: p) {
               // get the cell at indexPath (the one you long pressed)
               let cell = self.collectionView.cellForItem(at: indexPath)
               // we got current trip, now display q/alert about deleting
               
               
               
        
               let choiceAlert = UIAlertController(title: " Выберите действие", message: "", preferredStyle: .actionSheet)
               
            
            choiceAlert.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: {action in
                 let strb = UIStoryboard(name: "Main", bundle: nil)
                 let addGoalVC = strb.instantiateViewController(withIdentifier: "addGoalVC") as! AddGoalViewController
                 
                addGoalVC.trip = self.trip
                addGoalVC.delegate = self
                addGoalVC.editableGoal = self.goals[indexPath.item]
                addGoalVC.editMode = true
                 self.present(addGoalVC, animated: true, completion: nil)
                } ) )
            
            choiceAlert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
                self.deleteGoal(atIndex: indexPath)
            } ) )
            
            choiceAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: {action in
                   self.dismiss(animated: true, completion: nil)
               }))
               self.present(choiceAlert, animated: true, completion: nil)
               
           } else {
               print("couldn't find index path")
           }
       }
    
    func editGoal(goal: Goal){
        
    }
    
    func deleteGoal(atIndex: IndexPath){
        if atIndex.item >= goals.count {return}
        let goal = goals[atIndex.item]
        
        if Goal.deleteGoal(goal: goal){
            goals.remove(at: atIndex.item)
            collectionView.deleteItems(at: [atIndex])
        }
    }
    
    func addGoal(){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let yourWidth = collectionView.bounds.width - 30
        let yourHeight = yourWidth / 4
        
        return CGSize(width: yourWidth, height: yourHeight)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
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

protocol GoalsViewControllerDelegate {
    func update()
    func cellCheckedUnchecked(checked: Bool, indexPath: IndexPath)
}
