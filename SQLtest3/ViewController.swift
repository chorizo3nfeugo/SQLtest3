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
    
    
    
    
   var staffMemebers = ["  ", "Anil","Chris","Colin","Dale","Howard","Jenni","Marteen","Nicholas","Pardave","Ram","Victor","Zeus"]
   
    // Create exit out of ConfigView when "Done" button is pressed
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue)  {
     
    }

    
    var thePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.delegate = self
        thePicker.dataSource = self
        checkOutByField.inputView = thePicker
  
        self.navigationItem.setHidesBackButton(true, animated:true)
    
    }

               // Do any additional setup after loading the view, typically from a nib.
    
    @IBOutlet weak var itemNameField : UITextField!
    
    @IBOutlet weak var serialNumField : UITextField!
   
    @IBOutlet weak var checkOutByField : UITextField!
    
    @IBOutlet weak var assignedToField : UITextField!
    

    
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
    
    
    
//This clicks out of the screen after you input stuff in text fields
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

                        // this does not work when user clicks on return key
    func textFieldShouldReturn(_ itemNameField:UITextField) -> Bool {
        itemNameField.resignFirstResponder()
        return true
    }
    
// This code prepares everything in 1s view controlller and then passes it over to the confirmation page
    
 // *** Not declaring the Storyboard ID correctly here... 
    
    
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
    




        


    






    




