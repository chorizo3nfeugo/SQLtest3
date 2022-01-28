//
//  Alerts.swift
//  SQLtest3
//
//  Created by zeus on 2021-11-15.
//  Copyright © 2021 zeus. All rights reserved.
//

import Foundation

import UIKit

    final class Alert {
     
        class func showBasic(title: String, message:String, vc: UIViewController){
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
        
        
         class func addItem(title: String, message:String, vc: UIViewController){
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addTextField { (itemName) in
                itemName.placeholder = "Add New Item Here"
            }
            
            alert.addTextField { (itemName) in
                itemName.placeholder = "Serail Num"
            }
            
            let action = UIAlertAction(title: "Ok", style: .default) {(_) in
                guard let item = alert.textFields?.first?.text else {return}
                guard let serial = alert.textFields?.last?.text else {return}
                
                MultipleItemsVC.shared.itemsTest.append(item)
            
                
                print(item)
                print(serial)
            
            }
            let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })

            alert.addAction(action)
            alert.addAction(cancel)
            vc.present(alert, animated: true)
        }
        
        
//        func add(_ itemName:String){
//            MultipleItemsVC.shared.itemsTest.append(itemName)
//        }
        
    }
