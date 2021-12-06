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
        
        
       

/// Setting darkmode via assigning background to systemBackground
        if #available(iOS 13.0, *) {
                   view.backgroundColor = .systemBackground
               } else {
                   
               }
/// Cornering buttons!
        submitBtn.layer.cornerRadius = 6
        confirmLabel.clipsToBounds = true
        confirmLabel.layer.cornerRadius = 6
        

        

        
/// Create database file and connect to it
        do {
            let documentDirectory =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print (error)
        }
        
        
/// Create table
         let createTable = self.itemTable2.create {(table) in
                           table.column(self.id, primaryKey: true)
                           table.column(self.item)
                           table.column(self.assignedTo)
                           table.column(self.staff)
                           table.column(self.serial)
                           table.column(self.timecheck)
                       }
        
/// Execute  table creation in  database creation
                       do {
                           try self.database.run(createTable)
                           print ("Created Table")
                       }  catch {
                           print (error)
                       }
/// Set Serial to N/A if no serial num
        confirmItems[3] == "" ? confirmItems[3] = "N/A" : print("Serial Num Passed!")
        
    }
    
/// Database Variable
    var database:Connection!
    
/// Table properties
    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
    
    
/// Creates empty array here for first view controller
    var confirmItems = [String]()
    
///set time/date to convert it here in a function to then recall it over in the next function
    func checkOutTime()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string (from:Date())
        
    }
    
///When Submit button is pressed here,this func breaks apart the items into individual strings ready to load into SQLite DB
    @IBAction func submitBtn(_ sender: Any) {
   
        let i = confirmItems[0]
        let a = confirmItems[1]
        let c = confirmItems[2]
        let s = confirmItems[3]
        let t = checkOutTime()
       
        print(i)
        print(a)
        print(c)
        print(s)
        print(t)
       
            let insertItem = self.itemTable2.insert(self.item <- i,self.assignedTo <- a, self.staff <- c,self.serial <- s, self.timecheck <- t  )
                do {
                    try self.database.run (insertItem)
                    print("INSERTED USER")
                } catch {
                    print (error)
                }
        
}
 
    
    let cellDetails = ["Item: ","Assigned To: ","Signed Out By: ","Serial Num: "]
    
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var confirmLabel: UILabel!
    
    /// These public funcs here sorts out the passed items into the tableView
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (confirmItems.count)
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value2 , reuseIdentifier: "cell")
      
       
        cell.detailTextLabel?.text = confirmItems[indexPath.row]
        cell.textLabel?.text = cellDetails[indexPath.row]
        
        return (cell)
    
        }
    
}
    
    





