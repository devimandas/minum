//
//  HistoryViewController.swift
//  minum
//
//  Created by Ihwan ID on 12/05/20.
//  Copyright © 2020 Ihwan ID. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedDrinks(notification:)), name: Notification.Name("NotificationSaveDrinks"), object: nil)
//
//        let objToBeSent = "Save Drinks"
//                NotificationCenter.default.post(name: Notification.Name("NotificationSaveDrinks"), object: objToBeSent)
        
//        let objToBeSent = "Save Progress"
//                NotificationCenter.default.post(name: Notification.Name("NotificationSaveProgress"), object: objToBeSent)
        
        historyTable.dataSource = self
        historyTable.delegate = self
        historyTable.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
    
    }
    
//    @objc func methodOfReceivedDrinks(notification: Notification) {
//            print("Value of notification : ", notification.object ?? "")
//        }
    
//    @objc func methodOfReceivedNotification(notification: Notification) {
//            print("Value of notification : ", notification.object ?? "")
//        }
    
    func applicationDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetail") {
               let vc = segue.destination as! HistoryDetailViewController
            vc.id = sender as? String
           }
    }
}


extension HistoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drinks = CoreDataManager.shared.fetchDrinks()
        
        performSegue(withIdentifier: "toDetail", sender: drinks?[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = CoreDataManager.shared.fetchDrinks()
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let drinks = CoreDataManager.shared.fetchDrinks()
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        let arr: [History] = (drinks?[indexPath.row].history!.allObjects as? [History])!
    
        cell.desc.text = "You drank \(arr.map({$0.amount}).reduce(0, +)) ml water"
        cell.date.text = "\(drinks?[indexPath.row].date ?? "nodata")"
                 

        return cell
    }
    
    
    
}
