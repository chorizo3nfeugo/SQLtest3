//
//  TempItemObjects.swift
//  SQLtest3
//
//  Created by zeus on 2022-03-03.
//  Copyright © 2022 zeus. All rights reserved.
//

import Foundation

class TempItemObjects {

    private init(){}
    
    static let shared = TempItemObjects()

    public var itemsForMulti = [ItemForMulti]()
    
   public func printTest(){
    print("NUm of items in itemsForMulti is \(itemsForMulti.count)")
    }
    
    
    func saveItemsForMulti(){
        let defaults = UserDefaults.standard
        defaults.set(itemsForMulti, forKey: "TempItemsArray")
       // theStaffPicker.reloadAllComponents()
        print("Saved! List of Items  \(itemsForMulti)")
    }
    
/// Load method here to reload data into UIPicker via staffMembers
    public func loadItemsForMulti() {
        
        let defaults = UserDefaults.standard
        let newItemsArray = defaults.mutableArrayValue(forKeyPath: "TempItemsArray")
        itemsForMulti = newItemsArray as! [ItemForMulti]
        print("Loaded! Here's a list of items: \(itemsForMulti)")
   
        
      }
    
    
    public func deleteItemsForMulti(){
        let defaults = UserDefaults.standard
        itemsForMulti = [ItemForMulti]()
        defaults.set(itemsForMulti, forKey: "TempItemsArray")
        
    }
    
    // Initialize total sum here?
    
    
    
    
    
    func totalSumOfQty(){
        
       // var finalTotal:Int =  0
        
        let qtyNum = [itemsForMulti.map {$0.qty}]
       
        print(itemsForMulti)
        print("The qty number is \(qtyNum)")
        
        
     
    }

}
