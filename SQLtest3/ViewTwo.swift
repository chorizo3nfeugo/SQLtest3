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

class ViewTwo: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    
    override func viewDidLoad() {
      
        submitBtn.layer.cornerRadius = 5
        
    /// Open connection and restate  SQLdb values again here
        do {
            let documentDirectory =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print (error)
        }
        
    }
    
   
    var database:Connection!
    
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
   
        
         let createTable = self.itemTable2.create {(table) in
                   table.column(self.id, primaryKey: true)
                    table.column(self.item)
                    table.column(self.assignedTo)
                    table.column(self.staff)
                    table.column(self.serial)
                    table.column(self.timecheck)
                }
                do {
                    try self.database.run(createTable)
                    print ("Created Table")
        
                }  catch {
                    print (error)
                }
        
        let i = confirmItems[0]
        let a = confirmItems[1]
        let c = confirmItems[2]
        let s = confirmItems[3]
        let t = checkOutTime()
       
        print(i)
        print (a)
        print (c)
        print (s)
        print(t)
       
            let insertItem = self.itemTable2.insert(self.item <- i,self.assignedTo <- a, self.staff <- c,self.serial <- s, self.timecheck <- t  )
                do {
                    try self.database.run (insertItem)
                    print("INSERTED USER")
                } catch {
                    print (error)
                }
        
}
 
    
    @IBOutlet weak var submitBtn: UIButton!
    
    /// These public funcs here sorts out the passed items into the tableView
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (confirmItems.count)
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default , reuseIdentifier: "cell")
       
        cell.textLabel?.text = confirmItems[indexPath.row]
        
        
        return (cell)
    
        }
    
}
    
    





