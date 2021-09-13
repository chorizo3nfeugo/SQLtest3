//
//  ViewController.swift
//  SQLtest3
//
//  Created by zeus on 2018-10-12.
//  Copyright © 2018 zeus. All rights reserved.
//

import UIKit
import Foundation
import SQLite
import MessageUI

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
   
/// Create exit out of ConfigView when "Done" button is pressed
    @IBAction func unwindSegue(segue: UIStoryboardSegue)  {
     }

   /// Picker variable here
    var thePicker = UIPickerView()
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        configBtn.layer.cornerRadius = 5
        removeStaffBtn.layer.cornerRadius = 5
        addStaffBtn.layer.cornerRadius = 5
        confirmBtn.layer.cornerRadius = 5

    ///Load the picker here
        thePicker.delegate = self
        thePicker.dataSource = self
        checkOutByField.inputView = thePicker
        self.navigationItem.setHidesBackButton(true, animated:true)
        
    ///Create URL file path
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               
               fileURL = baseURL.appendingPathComponent("storedStaffNames.txt")
        
    ///load any users in staffmemebers and refresh the Picker scroll thing
        load()
     ///Setup initlal database connection here
        do {
                  let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
                  let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
                  let database = try Connection(fileUrl.path)
                  self.database = database
              } catch {
                  print(error)
              }

///Create table here. Table should just error out and proceed once it sees that table already exists after initial launch.
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
        
}
    
    @IBOutlet weak var configBtn: UIButton!
    
    
///create the Empty File here
var fileURL: URL!

/// Varibales for  connection to SQLite Database here
var database:Connection!
    
    let itemTable2  = Table("ItemCheck2")
               let id = Expression<Int> ("id")
               let item = Expression<String> ("item")
               let assignedTo = Expression<String>("assignedTo")
               let staff = Expression<String>("staff")
               let serial = Expression<String>("serial")
               let timecheck = Expression<String>("date")
    
              
    
    @IBOutlet weak var itemNameField : UITextField!
    
    @IBOutlet weak var serialNumField : UITextField!
   
    @IBOutlet weak var checkOutByField : UITextField!
    
    @IBOutlet weak var assignedToField : UITextField!
    

/// Container for stafff memebers here
    var staffMemebers:Array = [" - "]

/// Save func method to save any userinput vules for staffMembers
    func save(){
      
            let a = NSArray(array: staffMemebers)
        
            do {
                try a.write(to: fileURL)
            } catch  {
                print("Error Writing file")
            }
        thePicker.reloadAllComponents()
    
    }
/// Load method here to reload data into UIPicker
       func load() {
                   if let loadedData: [String] = NSArray(contentsOf: fileURL) as?  [String] {
               staffMemebers = loadedData
            thePicker.reloadAllComponents()
           }
           
       }
       
    
    
    @IBOutlet weak var addStaffBtn: UIButton!
    ///Add a staffname to the staff memeber array
    @IBAction func addStaffName(_ sender: Any) {
   let alert = UIAlertController(title: "Add Name", message:nil, preferredStyle: .alert )
            alert.addTextField {(tf) in tf.placeholder = "Add a Name" }
           
       let action = UIAlertAction(title:"Submit",style: .default) { (_) in
      
           let newName = alert.textFields?.first?.text
         
           return self.staffMemebers.append(newName!)
        
           }
           
           let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
           
           alert.addAction(action)
           alert.addAction(cancel)
           present(alert,animated: true,completion: nil)
    ///Saves and reloads the Picker  any new names to array
        save()
    }
    
    
    @IBOutlet weak var removeStaffBtn: UIButton!
    /// Remove a name from the staff memeber array
    @IBAction func removeStaffName(_ sender: Any) {
        
        let alert = UIAlertController(title: "Remove Name", message:nil, preferredStyle: .alert )
              alert.addTextField {(tf) in tf.placeholder = "Remove a Name" }
             
         let action = UIAlertAction(title:"Submit",style: .default) { (_) in
        
             let removeName = alert.textFields?.first?.text
            
            while self.staffMemebers.contains(removeName!) {
                if let itemToRemoveIndex = self.staffMemebers.index(of: removeName!) {
                    self.staffMemebers.remove(at: itemToRemoveIndex)
                    }
                }
            }
                let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
                     
                     alert.addAction(action)
                     alert.addAction(cancel)
                     present(alert,animated: true,completion: nil)
        ///Saves any names that have been removed and reloads the picker
            save()
    }
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    
/// UI Picker View func components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return staffMemebers.count
    }
    
    
    func pickerView(_ pickerView:UIPickerView,titleForRow row:Int, forComponent component:Int)-> String?{
        return staffMemebers[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        checkOutByField.text = staffMemebers[row]
    }
    
    
    
///This clicks out of the screen after you input stuff in text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        thePicker.reloadAllComponents()
    }

/// this does not work when user clicks on return key. Still need to find out why...
    func textFieldShouldReturn(_ itemNameField:UITextField) -> Bool {
        itemNameField.resignFirstResponder()
        return true
    }
    
/// This code prepares everything in 1s view controlller and then passes it over to the confirmation view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoConfirm" {
            
            let  DestViewController : ViewTwo = segue.destination as! ViewTwo
            DestViewController.confirmItems.insert( "\(itemNameField.text!)",at:0)
            DestViewController.confirmItems.insert ("\(assignedToField.text!)", at:1)
            DestViewController.confirmItems.insert ("\(checkOutByField.text!)",at:2)
            DestViewController.confirmItems.insert ("\(serialNumField.text!)",at:3)
            
        }
        
    }
    
}
    




        


    






    




