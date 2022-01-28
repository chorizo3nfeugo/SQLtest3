//
//  DatabaseFile.swift
//  SQLtest3
//
//  Created by zeus on 2018-10-30.
//  Copyright © 2018 zeus. All rights reserved.
//

import Foundation
import SQLite


public class SQLDataBase {
 
    static let shared = SQLDataBase()
    public init() {}

    func createDataBase(completion: @escaping (Connection) -> Void) {

// Create try conenction first and if fail then we create DB
        
        do {
            let documentDirectory =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
            let dataBase = try Connection(fileUrl.path)
            completion(dataBase)
          //  dataConnection = dataBase
            
        } catch {
            print (error)
        }
       
    }
    
    
    func createTable(db:Connection){
        
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
                                  try db.run(createTable)
                                  print ("Created Table")
                              }  catch {
                                  print (error)
                              }

    }
   
    
//Insert Items into Table
    
    func insertItems(db:Connection, item: String,assignedTo: String, staff:String, serial:String, timeCheck:String){
        
    let insertItem = self.itemTable2.insert(self.item <- item, self.assignedTo <- assignedTo, self.staff <- staff, self.serial <- serial, self.timecheck <- timeCheck
                                        )

        do {
            try db.run (insertItem)
            print("INSERTED NEW ITEM!")
        } catch {
            print (error)
        }
    }

    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
    
    
}



struct ItemContainter {
    
    let idNum:Int
    
    let itemName:String
    
    let assigned:String
    
    let staff:String
    
    let timeCheck: String
    
    let serialNum:String
}





///Thiere is nothing here yet! Coming soon in Version 2.0 ! 







