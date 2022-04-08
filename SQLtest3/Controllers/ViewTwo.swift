//
//  ViewTwo.swift
//  SQLtest3
//
//  Created by zeus on 2018-10-12.
//  Copyright © 2018 zeus. All rights reserved.
//

import Foundation
import UIKit
import SQLite

final class ViewTwo: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    override func viewDidLoad() {

        self.title = "Confirm Item Details!"
        

        
/// Setting darkmode via assigning background to systemBackground
        if #available(iOS 13.0, *) {
                   view.backgroundColor = .systemBackground
                    
               } else {
                   
               }
        submitBtn.layer.cornerRadius = 6

//MARK: -                                                Create database file and connect to it
        
        SQLDataBase.shared.createDataBase(){ createDb  in
            self.database = createDb
        }
        
// Old Ways to create/Add tables
        
 ///MARK: - When testing old way to make table, make sure to insert at least 1 row of items into table, otherwise table will not be created!!!
 // SQLDataBase.shared.createOldTable(db: database)

    
//MARK: - MUST IMPROVE THIS LOGIC TO SOMETHING LIKE: CONNECT TO DB + TABLE IF NOT CREATE TABLE / UPDATE TABLE because right now it's just creating / updating everytime we launch this screen...
   
        
    SQLDataBase.shared.doesTableExist(db: database)
   SQLDataBase.shared.createNewTable(db: database)

        
//    SQLDataBase.shared.doesTableExistBool(db: database)
        
  
  
        
        
        
// New Scritpt for one shot create/update/fallbacl
        
//   SQLDataBase.shared.createTableOrAdd(db: database)

/// Set Serial to N/A if no serial num
        
        confirmItems[3] == "" ? confirmItems[3] = "N/A" : print("Serial Num Passed!")
        
        // Run script to add a new return date column to database and return print statement wether it succedded or not.
        
        
    }
    

    var database:Connection!
    

    func checkOutTime()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string (from:Date())
        
    }

/// Creates empty array here for first view controller
        var confirmItems = [String]()
    
///When Submit button is pressed here,this func breaks apart the items into individual strings ready to load into SQLite DB
    @IBAction func submitBtn(_ sender: Any) {
   
        let item = confirmItems[0]
        let assignedTo = confirmItems[1]
        let staff  = confirmItems[2]
        let serialNum = confirmItems[3]
        let returnTime = confirmItems[4]
        let timeCheck = checkOutTime()

       
        print(item)
        print(assignedTo)
        print(staff)
        print(serialNum)
        print(timeCheck)
       
   SQLDataBase.shared.insertItems(db: database, item: item, assignedTo: assignedTo, staff: staff, serial: serialNum, timeCheck: timeCheck)
        
   //     SQLDataBase.shared.insertItemsV2(db: database, item: item, assignedTo: assignedTo, staff: staff, serial: serialNum, timeCheck: timeCheck, returnDate: returnTime)
}
 
    @IBOutlet weak var submitBtn: UIButton!
   // @IBOutlet weak var confirmLabel: UILabel!
    
    let cellDetails = ["Item: ","Assigned To: ","Signed Out By: ","Serial: ","Return By: "]
    
    /// These public funcs here sorts out the passed items into the tableView
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (confirmItems.count)
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "cell")
      
       
        cell.detailTextLabel?.text = confirmItems[indexPath.row]
        
        cell.textLabel?.text = cellDetails[indexPath.row]

        
        cell.textLabel?.textAlignment = .center
        
        cell.detailTextLabel?.textAlignment = .left

        
        return (cell)
    
        }
    
}
    
    





