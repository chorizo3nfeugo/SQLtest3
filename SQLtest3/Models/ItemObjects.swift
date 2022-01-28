//
//  ItemObjects.swift
//  SQLtest3
//
//  Created by zeus on 2022-01-24.
//  Copyright © 2022 zeus. All rights reserved.
//

import Foundation



class ItemObject {
    
    var idNum:Int
    
    var itemName:String
    
    var assigned:String
    
    var staff:String
    
    var timeCheck: String
    
    var serialNum:String
    
    init(idNum: Int, itemName: String, assigned: String, staff: String, timeCheck:String, serialNum:String ){
        self.idNum = idNum
        self.itemName = itemName
        self.assigned = assigned
        self.staff = staff
        self.timeCheck = timeCheck
        self.serialNum = serialNum
    }
    
}

// Use this in multi VC to show multiple objects for item
class ItemObjectMulti:ItemObject{
    
    var qty = 1
    
}

class ItemForMulti {
    
    var itemName: String
    var serialNum: String
    var qty: Int
    init(itemName: String, serialNum: String, qty: Int) {
        self.itemName = itemName
        self.serialNum = serialNum
        self.qty = qty
      
    }
    
}

// MARK: - THIS CREATES A CLASS FOR EMPTY INITILIZERS
//class ItemForMulti {
//
//    var itemName: String?
//    var serialNum: String?
//
//    init() {}
//
//    init(itemName: String, serialNum: String) {
//        self.itemName = itemName
//        self.serialNum = serialNum
//
//    }
//
//}