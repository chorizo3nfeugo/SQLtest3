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
        
        do {
            let documentDirectory =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print (error)
        }
        
    }
    
    // Create connection and retate SQLdb values again here
    var database:Connection!
    
    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
    
    
    // Creates empty array here for first view controller
    
    var confirmItems = [String]()
    
    //set time/date to convert it here in a function to then recall it over in the next function
    
    func checkOutTime()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string (from:Date())
        
    }
    
    //When Submit button is pressed here,this func breaks apart the items into individual strings ready to load into SQLite DB
    
    @IBAction func submitBtn(_ sender: Any) {
   
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

        
    // Will then have to send this data here over to the SQL db... need to figure out how to talk to SQL db connection here, by adding the conenction properties in this swift file?
   //----------------------
 //       **** ERROR **** SQLtest3[1048:21959] [logging] table ItemCheck has no column named assignedTo
//        table ItemCheck has no column named assignedTo (code: 1)
//-----------------
//
//        print(name)
//        print(email)
//
//        let insertUser = itemTable (self.item <- i,self.assignedTo <- a, self.staff <- c,self.serial <- s, self.timecheck <- t  )
//
//        do {
//            try self.database.run (insertUser)
//            print("INSERTED USER")
//        } catch {
//            print (error)
//        }
//
        
}
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (confirmItems.count)
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default , reuseIdentifier: "cell")
       
        cell.textLabel?.text = confirmItems[indexPath.row]
        
        
        return (cell)
    
        }
    
}
    
    




//
//    let cellID = "123"
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView.register (UITableView.self, forCellReuseIdentifier: cellID)
//        return 0
//    }
//
//
//
//
//
//
//    let record = ["item1","item2", "item3"]
//
//
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier:cellID   )
//        let record = self.record[indexPath.row]
//        cell?.textLabel?.text = record
//        return cell!
//        }


        // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
        
        // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)


    // Default is 1 if not implemented
    

