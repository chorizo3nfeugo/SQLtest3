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
    
    
    @IBOutlet var buttonsArray: [UIButton]!
    
    @IBOutlet var textFieldArray: [UITextField]!
    
/// Create exit out of ConfigView when "Done" button is pressed
    @IBAction func unwindSegue(segue: UIStoryboardSegue)  {
     }

    override func viewDidLoad() {
        
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        
        for button in buttonsArray {
            button.layer.cornerRadius = 6
        }
// Load the staffmemmbers into the Picker
        
        
         
    ///Load the picker here
        thePicker.delegate = self
        thePicker.dataSource = self
        checkOutByField.inputView = thePicker
        self.navigationItem.setHidesBackButton(true, animated:true)
        load()
   
        // Create DataBase function here
        
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
        
// Execute  table creation
               do {
                   try self.database.run(createTable)
                   print ("Created Table")
               }  catch {
                   print (error)
               }
        if traitCollection.userInterfaceStyle == .dark {
           
            for text in textFieldArray {
                text.backgroundColor = .darkGray
              //  text.textColor = .cyan
            }
        }
        
    }
        
 
    
    @IBOutlet weak var configBtn: UIButton!
    
    

    
   
          

               
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
    var staffMemebers2 = [""]{
    // This reloads thePicker once the array has been modified
        didSet {
            thePicker.reloadAllComponents()
            print("staffMemebers have been set")
        }
    }

    var staffMembers = [String](){
        didSet {
            thePicker.reloadAllComponents()
            print("There are \(staffMembers.count) from the didSet Variable")
        }
    }
    
    var thePicker = UIPickerView()

/// Save func method to save any userinput vules for staffMembers
    func save(){
        
        
      
//            let a = NSArray(array: staffMemebers)
//
//            do {
//                try a.write(to: fileURL)
//
//                print("Saved staff memebers")
//
//            } catch  {
//                print("Error Writing file")
//            }
//        thePicker.reloadAllComponents()
      //  staffMembers.append(assignedToField.text!)
        let defaults = UserDefaults.standard
        defaults.set(staffMembers, forKey: "SavedStaffArray")
        thePicker.reloadAllComponents()
        print("Saved! Here's a list of staff  \(staffMembers)")
    
    }
/// Load method here to reload data into UIPicker
       func load() {
//                   if let loadedData: [String] = NSArray(contentsOf: fileURL) as?  [String] {
//               staffMemebers = loadedData
//            thePicker.reloadAllComponents()
//           }
//        print("Staff Members Loaded!")
        let defaults = UserDefaults.standard
        let newArray = defaults.stringArray(forKey: "SavedStaffArray") ?? [String]()
        
        staffMembers = newArray
        thePicker.reloadAllComponents()
        print("Loaded! Here's a list of staff  \(staffMembers)")
        
    }
       
    
    
    @IBOutlet weak var addStaffBtn: UIButton!
///Add a staffname to the staff memeber array
    @IBAction func addStaffName(_ sender: Any) {
        
    

        let alert = UIAlertController(title: "Add Name", message:nil, preferredStyle: .alert )
        alert.addTextField {(tf) in tf.placeholder = "Add a Name" }

        let action = UIAlertAction(title:"Submit",style: .default) { (_) in


        let newName = alert.textFields?.first?.text
        
        self.staffMembers.append(newName!)
        
        return self.save()

           }

           let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })

           alert.addAction(action)
           alert.addAction(cancel)
           present(alert,animated: true,completion: nil)
///Saves and reloads the Picker  any new names to array
        print("Staff Member saved! There are now \(self.staffMembers.count) staff! ")

    }
    
    
    @IBOutlet weak var removeStaffBtn: UIButton!

/// Remove a name from the staff memeber array
    @IBAction func removeStaffName(_ sender: Any) {
        
        let alert = UIAlertController(title: "Remove Name", message:nil, preferredStyle: .alert )
              alert.addTextField {(tf) in tf.placeholder = "Remove a Name" }
             
         let action = UIAlertAction(title:"Submit",style: .default) { (_) in
        
             let removeName = alert.textFields?.first?.text
            
            while self.staffMembers.contains(removeName!) {
                if let itemToRemoveIndex = self.staffMembers.index(of: removeName!) {
                    self.staffMembers.remove(at: itemToRemoveIndex)
                    }
                }
            return self.save()
            }
                let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
                     
                     alert.addAction(action)
                     alert.addAction(cancel)
                     present(alert,animated: true,completion: nil)
///Saves any names that have been removed and reloads the picker
            save()
             print("Staff Member Removed! There are now \(staffMembers.count) staff! ")
            
    }
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBAction func confirmBtnCheck(_ sender: Any) {
        
        if itemNameField.text!.isEmpty || assignedToField.text!.isEmpty {
            
            Alert.showBasic(title: "Missing data!", message: "Please put in an item and assign to someone!", vc: self)
        }
        
        if assignedToField.text!.isEmpty || checkOutByField.text!.isEmpty {
            
            Alert.showBasic(title: "Missing Data! ", message: "Please make sure item is assigned to someone and is signed out by appropriate staff!", vc: self)
        }
}
    
    
    
/// UI Picker View func components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return staffMembers.count
    }
    
    
    func pickerView(_ pickerView:UIPickerView,titleForRow row:Int, forComponent component:Int)-> String?{
 // Fix error here because once you delete the staff member and click on UItextfield it errors with "OUT OF RANGE"
  //      load()
      //  thePicker.reloadAllComponents()
        return staffMembers[row]
        
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
       
        if staffMembers.isEmpty {
            return Alert.showBasic(title: "Please Add Staff Member!", message: "Click that plus button!", vc: self)
        }
        
        checkOutByField.text = staffMembers[row]
        
    }
    
    
    
    
///This clicks out of the screen after you input stuff in text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        thePicker.reloadAllComponents()
        self.view.endEditing(true)

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
    




        


    






    




