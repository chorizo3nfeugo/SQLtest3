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
    
    
    func checkTableItems(db:Connection){
        do {
            let all = Array(try db.prepare(itemTable2))
            print("here is them database items")
            print(all)
        } catch {
            
            print("SELECT * from ItemCheck2 table could not be run!")
        }
        
        // SELECT * FROM "users"
    }
    
    
    func doesTableExistBool(db:Connection){
        
        var tableExists = false
        
        let table = Table("ItemCheck2")
        
        do {
            
            print(try db.scalar(table.exists))
            tableExists = true
            
           print(tableExists)
            
            
        } catch {
            
       print(tableExists)
            //doesn't
        
        }
    }
    
    func addColumn(db:Connection){
       
        let addReturnDate = self.itemTable2.addColumn(Expression<String?>(returnDate))
        let table = Table("ItemCheck2")
        do {
            let itExists = try db.scalar(table.exists)
            if itExists {
                do {
                    try db.run(addReturnDate)
                } catch {
                    print("Could not add column because exists or error")
                }
            }
        } catch {
        print("Did not even run the script at all for new column")
        }
    }
    
    
    
    func createNewTable(db:Connection) {
    
        let createTable = self.itemTable2.create(ifNotExists: true) {(table) in
                          table.column(self.id, primaryKey: true)
                          table.column(self.item)
                          table.column(self.assignedTo)
                          table.column(self.staff)
                          table.column(self.serial)
                          table.column(self.timecheck)
                          table.column(self.returnDate)

        }
    
        do {
            try db.run(createTable)
            print("created New Table with returnDate column")
        } catch {
            
            print("Table could not be create or already exists. Will be adding column if possible")
            print(error)
     //       addColumn(db: db)
        }
        
//        do {
//
//            try db.run(createTable)
//            print ("Created Table")
//        }  catch {
//            print (error)
//            print("Table did not create or already created!")
//        }
    }
    
    
    
    
    func createOldTable(db:Connection){
        
        let createTable = self.itemTable2.create{(table) in
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
                                    print("Table did not create or already created!")
                              }
    
        
    }
   
    func doesTableExist(db: Connection){
        
        let table = Table("ItemCheck2")
    
        do {
            let itExists = try db.scalar(table.exists)
//            let tableInfo = Array(try db!.prepare("PRAGMA table_info(table)"))
//
//            let foundColumn = tableInfo.filter {
//                col in col[1] as! String == "returnDate"
//            }
 
            if itExists {
                print("ItemCheck2 Table exists and will be adding column to it")
                print(itExists)
                let addReturnDate = self.itemTable2.addColumn(Expression<String?>(returnDate))
                do {
                    try db.run(addReturnDate)
                    print("Added ReturnDate to Table")
                } catch {
                    print(error)
                    print("ReturnDate already added")
                }
            } else {
                print(" Item Check2 does not exist! ")
               
            }
            
            
        } catch {
            
            print("Could  not add new colum 'returnDate'or Already added new column! " )
            print(error)
        }
        
    }
    

    
  // OLD Insert way with no returnDATE
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
    
 // NEW INSERTED WAY WITH RETURNDATE
    func insertItemsV2(db:Connection, item: String,assignedTo: String, staff:String, serial:String, timeCheck:String, returnDate:String){
        
        let insertItem = self.itemTable2.insert(self.item <- item, self.assignedTo <- assignedTo, self.staff <- staff, self.serial <- serial, self.timecheck <- timeCheck, self.returnDate <- returnDate
                                        )

        do {
            try db.run (insertItem)
            print("INSERTED NEW ITEM w/ returnDate!")
        } catch {
            print (error)
        }
    }
    

///Note: table name is called    "ItemCheck2 "
    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
// Adding new column
    let returnDate = Expression<String>("returnDate")
    
    
//    
//    func addColumn(db:Connection){
//        
//    do {
//        let addReturnDate = self.itemTable2.addColumn(self.returnDate)
//        
//        try db.run(addReturnDate)
//        
//       } catch {
//           print(error)
//       }
//    }
    
    
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







