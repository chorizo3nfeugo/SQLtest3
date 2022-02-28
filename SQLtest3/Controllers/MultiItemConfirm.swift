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

        self.title = "Assign & Sign Out"
        confirmBtnView.layer.cornerRadius = 6
        theStaffPicker.delegate = self
        theStaffPicker.dataSource = self
        checkedOutBy.inputView = theStaffPicker
        configStaffPicker()
        homeVC.loadStaffMembers()
        
    }
    

    
    
    @IBOutlet weak var assignedTo: UITextField!
    
    @IBOutlet weak var checkedOutBy: UITextField!
    
    @IBOutlet weak var confirmBtnView: UIButton!
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        switch true {
        case assignedTo.text?.isEmpty: Alert.showBasic(title: "Missing Assigned To!", message: "Fill in Assiged To! Where/who are these items going to?", vc: self)
        case checkedOutBy.text?.isEmpty: Alert.showBasic(title: "Missing Data", message: "Select Staff memeber for Signed out by!", vc: self)
        default: print("default triggered")
            
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
