//
//  MultiItemConfirm.swift
//  SQLtest3
//
//  Created by zeus on 2022-02-28.
//  Copyright © 2022 zeus. All rights reserved.
//

import UIKit

class MultiItemConfirm: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    
    var theStaffPicker = UIPickerView()
    
    let homeVC = HomeViewController.shared
    
    var itemsInCart = [ItemForMulti]()
    
    
    func totalSumOfQty()-> Int {
        
       // var finalTotal:Int =  0
        
        let qtyNum = itemsInCart.map {$0.qty}
       // add everything in array
        
        let sum = qtyNum.reduce(0,+)
        
        print("The total number of items is \(sum)")
        
        return sum
    }
    
    
    func configStaffPicker(){
             let toolbar = UIToolbar()
             
             toolbar.sizeToFit()
             
    ///create done button
             let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
             toolbar.setItems([doneBtn], animated: true)
             
        checkedOutBy.inputAccessoryView = toolbar
        
         }
    
    @objc func donePressed(){
        print("DONE BUTTON CREATED")
        self.view.endEditing(true)
        }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        returnDate.isHidden = true

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
            
            if traitCollection.userInterfaceStyle == .dark {
                assignedTo.backgroundColor = .darkGray
                checkedOutBy.backgroundColor = .darkGray
                returnDate.backgroundColor = .darkGray
            }
// Adjust size of DatePicker
            returnItemsDatePicker.preferredDatePickerStyle = .inline
            returnItemsDatePicker.sizeToFit()
        
        } else {
            // Fallback on earlier versions
        }
        
   
        
        self.title = "Assign & Sign Out"
        confirmBtnView.layer.cornerRadius = 6
        totalItemsLabel.layer.cornerRadius = 6
        totalItemsLabel.clipsToBounds = true
        theStaffPicker.delegate = self
        theStaffPicker.dataSource = self
        checkedOutBy.inputView = theStaffPicker
// Load in number of QTY here into sumOfItemsLabel
        
        totalItemsLabel.text = "\(totalSumOfQty())"
        
        configStaffPicker()
        homeVC.loadStaffMembers()
        createReturnDatePicker()
        
    }
    

    
    @IBOutlet weak var totalItemsLabel: UILabel!
    
    @IBOutlet weak var assignedTo: UITextField!
    
    @IBOutlet weak var checkedOutBy: UITextField!
    
    //MARK: - Add global item return date switch and hidden text field here. 
    
    @IBOutlet weak var returnDate: UITextField!
    
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var confirmBtnView: UIButton!
    
    @IBAction func returnDateSwitch(_ state: UISwitch) {
        
        if state.isOn {
            returnDateLabel.text = "Return Date:"
            returnDate.isHidden = false
           // createReturnDatePicker()
           
        } else{
            returnDateLabel.text = "Return Date?"
            returnDate.isHidden = true
            returnDate.text = ""
        }
        
    }
    
    
    
    var returnItemsDatePicker = UIDatePicker()
    
    func createReturnDatePicker(){
                 let toolbar = UIToolbar()
                 
                 toolbar.sizeToFit()
                 
        ///create done button
                 let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDateBtn))
        
                 toolbar.setItems([doneBtn], animated: true)
                 
        /// Assign toolbar
                 returnDate.inputAccessoryView = toolbar
               
        ///Assign date picker to the text field
            returnDate.inputView = returnItemsDatePicker
                 
        /// Assign date picker to end date text field
           
            returnItemsDatePicker.datePickerMode = .date
                
             }
    
    @objc func doneDateBtn(){
        //Format Date here
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        // Then assign new date formats to labels here
        
        returnDate.text = formatter.string(from:returnItemsDatePicker.date)
        
      //  returnDateField.text = formatter.string()
                self.view.endEditing(true)
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
    
    
    
    @IBAction func confirmBtn(_ sender: Any) {
         
        let assignCheck = assignedTo.text?.isEmpty
        let checkOutCheck = checkedOutBy.text?.isEmpty
        let dateCheck = returnDateCheck(chosenDate: returnDate.text!)

        switch true {
        case assignCheck: Alert.showBasic(title: "Missing Assigned To!", message: "Fill in Assiged To! Where/who are these items going to?", vc: self)
        case checkOutCheck: Alert.showBasic(title: "Missing Data", message: "Select Staff memeber for Signed out by!", vc: self)
        case dateCheck: Alert.showBasic(title: "Time Traveller eh?", message: "Please select a date in the future for return date!", vc: self)
        default: print("default triggered")
            }
        
    }
    
    
    
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMSubmitVC" {
            
            let  DestViewController : MultiItemSubmitVC = segue.destination as! MultiItemSubmitVC
         
 // Insert assignee and checkOutby label into itemsINcart
           
            
            DestViewController.finalItemsToSubmit = itemsInCart
 //
            DestViewController.assigneeName = assignedTo.text!
            DestViewController.staffName = checkedOutBy.text!
 //
            DestViewController.totalItems = totalItemsLabel.text!
            DestViewController.returnDate = returnDate.text!
        
            
            
        }
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return homeVC.staffMembers.count
    }
    
    
    func pickerView(_ pickerView:UIPickerView,titleForRow row:Int, forComponent component:Int)-> String?{
        return homeVC.staffMembers[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
/// Alert inserted here to let user know to put in at least one staff memeber if staffMembers is empty
        if homeVC.staffMembers.isEmpty {
            return Alert.showBasic(title: "Please Add A Staff Member!", message: "Click that plus button!", vc: self)
        } else {
            checkedOutBy.text = homeVC.staffMembers[row]
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
