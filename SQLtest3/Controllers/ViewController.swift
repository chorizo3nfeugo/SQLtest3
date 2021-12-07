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

final class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
/// Creating button and textfield arrays for later manipulation
    @IBOutlet var buttonsArray: [UIButton]!
    @IBOutlet var textFieldArray: [UITextField]!
    
    
    var dataBaseDeleted:Bool = false
    
///    Create exit out of ConfigView when "Done" button is pressed
    @IBAction func unwindSegue(segue: UIStoryboardSegue)  {
     }
    
    override func viewDidLoad() {
  // MARK: - viewDidLoad
        
       super.viewDidLoad()
        
///    Darkmode check
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            for text in textFieldArray {
                text.backgroundColor = .darkGray
            }
        }
        
///     Button rounding
        for button in buttonsArray {
            button.layer.cornerRadius = 6
        }
        
///    Load the picker here
        theStaffPicker.delegate = self
        theStaffPicker.dataSource = self
        checkOutByField.inputView = theStaffPicker
        self.navigationItem.setHidesBackButton(true, animated:true)
        
///    Call load function to load in staff memebers to picker
        loadStaffMembers()

/// Database check here to make sure items  are there or not
        print("Database deleted?  \(dataBaseDeleted)")
        dataBaseDeleted == true ? Alert.showBasic(title: "All Items Deleted!", message: "Have a great day!", vc: self) : print("Database is saved and all good!")
        
    }
        

    @IBOutlet weak var configBtn: UIButton!
    @IBAction func configBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoConfig", sender: self)
    }
    
    
    @IBOutlet weak var itemNameField : UITextField!
    
    @IBOutlet weak var serialNumField : UITextField!
   
    @IBOutlet weak var checkOutByField : UITextField!
    
    @IBOutlet weak var assignedToField : UITextField!
  
    
/// Picker variable assigned to UIPicker
    var theStaffPicker = UIPickerView()
    
/// Array of staff members here which then reloads picker once it's been changed.
    var staffMembers = [String](){
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
    func loadStaffMembers() {
        
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
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBAction func confirmBtnCheck(_ sender: Any) {
        
///These statments check if all fields are filled out accordingly.
        
        if itemNameField.text!.isEmpty || assignedToField.text!.isEmpty {
            
            Alert.showBasic(title: "Missing data!", message: "Please put in an item and assign to someone!", vc: self)
        }
        
        if assignedToField.text!.isEmpty || checkOutByField.text!.isEmpty {
            
            Alert.showBasic(title: "Missing Data! ", message: "Please make sure item is assigned to someone and is signed out by appropriate staff!", vc: self)
        }
}
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return staffMembers.count
    }
    
    
    func pickerView(_ pickerView:UIPickerView,titleForRow row:Int, forComponent component:Int)-> String?{
        return staffMembers[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
/// Alert inserted here to let user know to put in at least one staff memeber if staffMembers is empty
        if staffMembers.isEmpty {
            return Alert.showBasic(title: "Please Add A Staff Member!", message: "Click that plus button!", vc: self)
        } else {
            checkOutByField.text = staffMembers[row]
        }
    }
    
///This clicks out of the screen after you input stuff in text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        theStaffPicker.reloadAllComponents()
        self.view.endEditing(true)
    }

/// Uuser clicks on return key and keyboard pops off..
    func textFieldShouldReturn(_ itemNameField:UITextField) -> Bool {
        itemNameField.resignFirstResponder()
        return true
    }
    
/// This UIStoryboardSegue prepares  everything in this  view controlller and then passes it over to the  viewTwo controller
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
    




        


    






    




