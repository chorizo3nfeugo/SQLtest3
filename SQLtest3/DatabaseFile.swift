//
//  DatabaseFile.swift
//  SQLtest3
//
//  Created by zeus on 2018-10-30.
//  Copyright © 2018 zeus. All rights reserved.
//

import Foundation
import SQLite


//func initializeSQLiteDb{
//    
//    let mainVC = ViewController.init()
//    
//            do {
//                      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
//                      let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
//                      let database = try Connection(fileUrl.path)
//                      self.database = database
//                  } catch {
//                      print(error)
//                  }
//
//    ///Create table here. Table should just error out and proceed once it sees that table already exists after initial launch.
//            let createTable = self.itemTable2.create {(table) in
//                       table.column(self.id, primaryKey: true)
//                       table.column(self.item)
//                       table.column(self.assignedTo)
//                       table.column(self.staff)
//                       table.column(self.serial)
//                       table.column(self.timecheck)
//                   }
//            
//    // Execute  table creation
//                   do {
//                       try self.database.run(createTable)
//                       print ("Created Table")
//                   }  catch {
//                       print (error)
//                   }
//
//}




struct ItemContainter {
    
    let idNum:Int
    
    let itemName:String
    
    let assigned:String
    
    let staff:String
    
    let timeCheck: String
    
    let serialNum:String
}





///Thiere is nothing here yet! Coming soon in Version 2.0 ! 







