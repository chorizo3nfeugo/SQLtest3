//
//  MultiItemSubmitVC.swift
//  SQLtest3
//
//  Created by zeus on 2022-02-28.
//  Copyright © 2022 zeus. All rights reserved.
//

import UIKit
import SQLite

class MultiItemSubmitVC: UIViewController {

    
     var finalItemsToSubmit = [ItemForMulti]()
    
    var assigneeName = "assignee"
    var staffName = "staffName"
    var totalItems = "0"
    var returnDate = "N/A"
    
    
    var database:Connection!
    
    
    
    
    func checkOutTime()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string (from:Date())
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        finalItemsTableView.delegate = self
        finalItemsTableView.dataSource = self
        
        
        
        self.title = "Submit \(totalItems) Items"
        submitBtnView.layer.cornerRadius = 6
        
        assigneeLabel.text = assigneeName
        staffLabel.text = staffName
        returnDateLbl.text = returnDate
        
//MARK: - Open SQLite Database
        SQLDataBase.shared.createDataBase(){ createDb  in
            self.database = createDb
        }
        
        SQLDataBase.shared.createOldTable(db: database)
        
        
        
    }
    
    @IBOutlet weak var assigneeLabel: UILabel!
    
    @IBOutlet weak var returnDateLbl: UILabel!
    
    @IBOutlet weak var staffLabel: UILabel!
    
    @IBOutlet weak var finalItemsTableView: UITableView!
    
    
    
    
    // MARK: - Add return Date per item and then show UItext which triggers Calander Selection
    
    
    @IBOutlet weak var submitBtnView: UIButton!
    @IBAction func submitBtn(_ sender: Any) {
        
        // Take serial numbers and item names to input
        // for total of serial numbers in finalItemsTosubmit we will insert items into db
        
                // let qtyToSubmit = finalItemsToSubmit.map {$0.qty}
        
        for items in finalItemsToSubmit {
            
            print(items.itemName.enumerated())
            
            let itemName = items.itemName
            
            for serialNum in items.serialNum {
                
                let assignedTo = assigneeName
                let staff  = staffName
                let timeCheck = checkOutTime()
                
                
        //        SQLDataBase.shared.insertItems(db: database, item: itemName, assignedTo: assignedTo, staff: staff, serial: serialNum, timeCheck: timeCheck )
                
                SQLDataBase.shared.insertItemsV2(db: database, item: itemName, assignedTo: assignedTo, staff: staff, serial: serialNum, timeCheck: timeCheck, returnDate: returnDate )
                
            }
        }
        
        print(finalItemsToSubmit.enumerated())
    
        
     
        
        
    }
  

   

    
}





extension MultiItemSubmitVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionLabel = finalItemsToSubmit[section].itemName + "    x  \(finalItemsToSubmit[section].qty)"
        
        return sectionLabel
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return finalItemsToSubmit.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalItemsToSubmit[section].serialNum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = finalItemsToSubmit[indexPath.section].serialNum[indexPath.row]
// Show detail text label with dates  only for chosen items and currently does not work! on  MARCH 7th!
        cell.detailTextLabel?.text = "Return Date here from MutliItemVC edit slide"
     
        return cell
    }
    
    
}

extension MultiItemSubmitVC: UITableViewDelegate {
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostSubmit" {
            
            let destVC : Postsubmition = segue.destination as! Postsubmition
            
            destVC.finalLabelText = "\(totalItems) Item's Submitted & Saved!"
            
            destVC.titleLabelText = "Item's Submitted"
            
        }
    }
}
