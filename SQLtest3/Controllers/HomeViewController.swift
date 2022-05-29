//
//  ViewController.swift
//  SQLtest3
//
//  Created by zeus on 2022-02-28.
//  Copyright © 2022 zeus. All rights reserved.
//

import UIKit


import UIKit
import Foundation
//import SQLite
//import MessageUI

 public class HomeViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
  
    

    
    static let shared = HomeViewController()
  
  
  
    
/// Creating button and textfield arrays for later manipulation
    @IBOutlet var buttonsArray: [UIButton]!
    @IBOutlet var textFieldArray: [UITextField]!
    @IBOutlet var itemPropertiesLbls: [UILabel]!
///    Create exit out of ConfigView when "Done" button is pressed
    @IBAction func unwindSegue(segue: UIStoryboardSegue)  {
     }
    @IBOutlet weak var configBtn: UIButton!
    
    @IBAction func configBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoConfig", sender: self)
    }
    
    
  
    
    
 
    
    @IBOutlet weak var itemNameField : UITextField!
    
    @IBOutlet weak var serialNumField : UITextField!
    
    @IBOutlet weak var checkOutByField : UITextField!
    
    @IBOutlet weak var assignedToField : UITextField!
  
    @IBOutlet weak var returnDateField: UITextField!
    
    
    
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var returnSwitchState: UISwitch!
    
    
    @IBAction func returnDateSwitch(_ state: UISwitch) {
        
        if state.isOn {
            returnDateLabel.text = "Return Date:"
            returnDateField.isHidden = false
           // createReturnDatePicker()
           
        } else{
            returnDateLabel.text = "Return Date?"
            returnDateField.isHidden = true
            returnDateField.text = nil
        }
    }
    
    var dataBaseDeleted:Bool = false

    var theStaffPicker = UIPickerView()
    
    
    func configPicker(){
             let toolbar = UIToolbar()
             
             toolbar.sizeToFit()
             
    ///create done button
             let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
             toolbar.setItems([doneBtn], animated: true)
             
        checkOutByField.inputAccessoryView = toolbar
        
         }


    // Objc C func for donebutton inside the createDatePickers func
    @objc func donePressed(){
        print("DONE BUTTON CREATED")
        self.view.endEditing(true)
        }
    
    //Mark:- Current Time check
    
    func checkOutTime()->String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
     //   formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string (from:Date())
    }
    
    
//    func returnDateTime() -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        let date = dateFormatter.date(from:isoDate)!
//    }
    
    

   // MARK:-                    ReturnDate initializers
    var returnDatePicker = UIDatePicker()
    
    func createReturnDatePicker(){
        
                 let toolbar = UIToolbar()
                 
                 toolbar.sizeToFit()
                 
        ///create done button
                 let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDateBtn))
        
                 toolbar.setItems([doneBtn], animated: true)
                 
        /// Assign toolbar
                 returnDateField.inputAccessoryView = toolbar
               
        ///Assign date picker to the text field
            returnDateField.inputView = returnDatePicker
                 
        /// Assign date picker to end date text field
        returnDatePicker.datePickerMode = .date
                
             }


        // Objc C func for donebutton inside the createDatePickers func
        @objc func doneDateBtn(){
            //Format Date here
            let formatter = DateFormatter()
            
            
            formatter.dateStyle = .short
            formatter.timeStyle = .none

// Then assign new date formats to labels here
            returnDateField.text = formatter.string(from:returnDatePicker.date)
//  returnDateField.text = formatter.string()
//  print(returnDateField.text)
                    self.view.endEditing(true)
            }
    
    
// MARK: -                                                              viewDidLoad
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Item Check"
        
        self.returnSwitchState.isOn = false
        self.returnDateField.isHidden = true
        
///    Darkmode check
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
            
            returnDatePicker.preferredDatePickerStyle = .inline
            returnDatePicker.sizeToFit()

            
        } else {
            // Fallback on earlier versions
        }
        if traitCollection.userInterfaceStyle == .dark {
            for text in textFieldArray {
                text.backgroundColor = .darkGray
            }
            
            for text in itemPropertiesLbls{
                text.textColor = .systemTeal
            }
        }
        ///     Button rounding
        for button in buttonsArray {
            button.layer.cornerRadius = 6
            ///Need this to have background image lock into cornerRadius for buttons
            
            button.clipsToBounds = true
        }
        
        
        ///    Load the picker here
        theStaffPicker.delegate = self
        theStaffPicker.dataSource = self
        checkOutByField.inputView = theStaffPicker
        
        
     //   returnDateField.inputView = returnDatePicker
        
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        configPicker()
        createReturnDatePicker()
        
        ///    Call load function to load in staff memebers to picker
        loadStaffMembers()
        
        /// Database check here to make sure items  are there or not
        print("Database deleted?  \(dataBaseDeleted)")
        
        dataBaseDeleted == true ? Alert.showBasic(title: "All Items Deleted!", message: "Have a great day!", vc: self) : print("Database is saved and all good!")
        
    }

    
    
   
    
/// Array of staff members here which then reloads picker once it's been changed.
    public var staffMembers = [String](){
        didSet {
            theStaffPicker.reloadAllComponents()
            print("didSet: There are \(staffMembers.count) staff memebers")
        }
    }
    
/// Save func method to save new staff to staffMembers
    func saveStaffMembers(){
        let defaults = UserDefaults.standard
        defaults.set(staffMembers, forKey: "SavedStaffArray")
        theStaffPicker.reloadAllComponents()
        print("Saved! Here's the new list of staff members  \(staffMembers)")
    }
    
/// Load method here to reload data into UIPicker via staffMembers
    public func loadStaffMembers() {
        
        let defaults = UserDefaults.standard
        let newArray = defaults.stringArray(forKey: "SavedStaffArray") ?? [String]()
        staffMembers = newArray
        theStaffPicker.reloadAllComponents()
        print("Loaded! Here's a list of staff Names  \(staffMembers)")
    }
       
    
    
    
    @IBOutlet weak var addStaffBtn: UIButton!
    @IBAction func addStaffName(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Name", message:nil, preferredStyle: .alert )
        alert.addTextField {(tf) in tf.placeholder = "Add a Name" }

        let action = UIAlertAction(title:"Submit",style: .default) { (_) in

        let newName = alert.textFields?.first?.text
        
        self.staffMembers.append(newName!)
        
        return self.saveStaffMembers()
           }
           let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })

           alert.addAction(action)
           alert.addAction(cancel)
           present(alert,animated: true,completion: nil)

        print("Staff Member saved! There are now \(self.staffMembers.count) staff! ")
    }
    
    
    @IBOutlet weak var removeStaffBtn: UIButton!
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
            print("Staff Member Removed! There are now \(self.staffMembers.count) staff! ")
            return self.saveStaffMembers()
            }
                let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
                     
                alert.addAction(action)
                alert.addAction(cancel)
                present(alert,animated: true,completion: nil)
        
    }
    
    func currentTime()->String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string (from:Date())
    }
    
    func returnDateCheck(chosenDate: String)-> Bool {

        var dateSwitch = false

        if chosenDate == "" {
            
           return dateSwitch
        } else if chosenDate < currentTime() {
            dateSwitch = true
            return dateSwitch
        } else {
            return dateSwitch
        }
        
    }
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBAction func confirmBtnCheck(_ sender: Any) {
        
///These statments check if all fields are filled out accordingly.
        
        let dateCheck = returnDateCheck(chosenDate: returnDateField.text!)
        
        if itemNameField.text!.isEmpty || assignedToField.text!.isEmpty {
            
            Alert.showBasic(title: "Missing Data!", message: "Please put in an item and assign to someone!", vc: self)
        }
        
        if assignedToField.text!.isEmpty || checkOutByField.text!.isEmpty {
            
            Alert.showBasic(title: "Missing Data! ", message: "Please make sure item is assigned to someone and is signed out by appropriate staff!", vc: self)
        }
            
//MARK:- Need to add return date check to make sure user selects a date in the future! Must error out if past is selected
        if dateCheck == true  {
           //  print(checkOutTime())
            Alert.showBasic(title: "You a Time Traveller?", message: "Please select a date in the future to return said item", vc: self)
        }
        
}
    
    

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return staffMembers.count
    }
    
    
    public func pickerView(_ pickerView:UIPickerView,titleForRow row:Int, forComponent component:Int)-> String?{
        return staffMembers[row]
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
/// Alert inserted here to let user know to put in at least one staff memeber if staffMembers is empty
        if staffMembers.isEmpty {
            return Alert.showBasic(title: "Please Add A Staff Member!", message: "Click that plus button!", vc: self)
        } else {
            checkOutByField.text = staffMembers[row]
        }
    }
    
///This clicks out of the screen after you input stuff in text fields
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        theStaffPicker.reloadAllComponents()
        self.view.endEditing(true)
    }

/// Uuser clicks on return key and keyboard pops off..
    func textFieldShouldReturn(_ itemNameField:UITextField) -> Bool {
        itemNameField.resignFirstResponder()
        return true
    }
    
/// This UIStoryboardSegue prepares  everything in this  view controlller and then passes it over to the  viewTwo controller
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoConfirm" {
            
            let  DestViewController : ViewTwo = segue.destination as! ViewTwo
            DestViewController.confirmItems.insert( "\(itemNameField.text!)",at:0)
            DestViewController.confirmItems.insert ("\(assignedToField.text!)", at:1)
            DestViewController.confirmItems.insert ("\(checkOutByField.text!)",at:2)
            DestViewController.confirmItems.insert ("\(serialNumField.text!)",at:3)
            DestViewController.confirmItems.insert("\(returnDateField.text!)", at: 4)
        }
        
    }
    
}
    




