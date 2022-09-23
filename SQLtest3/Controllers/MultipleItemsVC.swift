//
//  MultipleItemsVC.swift
//  SQLtest3
//
//  Created by zeus on 2022-01-19.
//  Copyright © 2022 zeus. All rights reserved.
//

import UIKit

class MultipleItemsVC: UIViewController {
    
    static let shared = MultipleItemsVC()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
            
        } else {
            // Fallback on earlier versions
        }
        
        self.title = "Add Items"
        
        
        assignBtnView.layer.cornerRadius = 6
                    /// You do not need the code below when using cutomTabelviewCell file, it will just break!
        assignBtnView.clipsToBounds = true

    
//    let item1 = ItemForMulti(itemName: "SexBox", serialNum: ["N/A"], qty: 1, assignedTo: "N/A", checkedBy: "N/A")
//    itemsCollection.append(item1)
//    print(itemsCollection.count)
//        
    }
    
    
    public var itemsTest = [String]()
    
    
  
//MARK: -  Remember to clear this out? Or does it happen when we come back after SQL submitting and saving??
    public var itemsCollection = [ItemForMulti]()

    
    
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    
    
    
    @IBAction func addItemBtn(_ sender: Any) {
        
   
        
        let alert = UIAlertController(title: "Add New Item!", message: "", preferredStyle: .alert)
        
        alert.addTextField { (itemName) in
            itemName.placeholder = "Add New Item Here"
        }
        
        alert.addTextField { (itemName) in
            itemName.placeholder = "Serail Num"
        }
        
      
        
        let action = UIAlertAction(title: "Ok", style: .default) {(_) in
            guard let item = alert.textFields?.first?.text else {return}
            guard var serial = alert.textFields?.last?.text else {return}
        
            if item.isEmpty {
                Alert.showBasic(title: "Item name is?..", message: "Please name the item accordingly", vc: self)
            } else {
                
                if serial.isEmpty {
                    serial = "N/A"
                }
                let newObject = ItemForMulti(itemName: item, serialNum: [serial], qty:1,assignedTo: "N/A",checkedBy: "N/A")
                self.add(newObject)
                print(newObject)
                
            }
            
        }
        
        
        let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })

        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
        print(itemsCollection)
    
    }

    
    func add(_ newObject: ItemForMulti) {
        
    let index = 0

    let indexPath = IndexPath(row: index, section: 0)

        itemsCollection.insert(newObject, at: index)
        
        let indexSet = IndexSet(arrayLiteral:indexPath.section)
        itemsTableView.insertSections(indexSet , with: .top)
       
    }

 

    @IBOutlet weak var assignBtnView: UIButton!
    
    @IBAction func assignedToBtn(_ sender: Any) {
        
        if itemsCollection.isEmpty {
            Alert.showBasic(title: "Need item(s)!", message: "Please add an item to list before proceeding to Assigned To", vc: self)
        }
    
        
    }
    

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemsConfirm" {
            
            let  DestViewController : MultiItemConfirm = segue.destination as! MultiItemConfirm
         
            DestViewController.itemsInCart = itemsCollection
        }
        
    }
    
    
    
   
}






extension MultipleItemsVC: UITableViewDataSource {
    

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  itemsCollection.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = itemsCollection[section]
        
        if section.isOpened {
            return section.serialNum.count + 1
        } else {
            
            return 1
            
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
                
        
        if indexPath.row == 0 {
            
            cell.backgroundColor = .systemIndigo
            cell.itemNameLabel.text = itemsCollection[indexPath.section].itemName
            cell.serialLabel.text = itemsCollection[indexPath.section].serialNum.first
            cell.qtyLabel.text = "Qty:"
            cell.qtyNum.text = "\(itemsCollection[indexPath.section].qty)"
            
            if itemsCollection[indexPath.section].qty > 1 {
                
                cell.itemNameLabel.text = itemsCollection[indexPath.section].itemName + "(s)"
                cell.serialLabel.text = "Tap to Exapnd"
                cell.qtyLabel.text = "Qty:"
                cell.qtyNum.text = "\(itemsCollection[indexPath.section].qty)"
                
                cell.addQtyBtn.isHidden = false
                cell.removeQtyBtn.isHidden = false
                
            } else if itemsCollection[indexPath.section].qty == 1 {
                cell.backgroundColor = .systemIndigo
                cell.itemNameLabel.text = itemsCollection[indexPath.section].itemName
                cell.serialLabel.text =  "Serial #: \(itemsCollection[indexPath.section].serialNum.first!)"
                cell.qtyLabel.text = "Qty:"
                cell.qtyNum.text = "\(itemsCollection[indexPath.section].qty)"
                cell.addQtyBtn.isHidden = false
                cell.removeQtyBtn.isHidden = false
            }
            
            
// MARK: REFACTOR? - CAN We condense the tappedbuttons to just one switch / if else control statement?

            cell.removeQtyTapped = { [self] (cell) in
  
                let rowNum = self.itemsCollection[indexPath.section]
                
                let newQty = rowNum.qty - 1
                
                rowNum.serialNum.removeLast()
                
                if newQty == 0 {
                
      
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
          
                        itemsCollection.remove(at: indexPath.section)
                        let indexSet = IndexSet(arrayLiteral: indexPath.section)
                        itemsTableView.deleteSections(indexSet, with: .left)
                        self?.itemsTableView.reloadData()
                    }
                    
        
                }
                
                rowNum.qty = newQty
        
                print(cell)
            
                print("\(rowNum.itemName) has  these folllowing serial numbers \(rowNum.serialNum)")
                
         
                self.itemsTableView.reloadData()
          
            }

            cell.addQtyTapped = { [self] (cell) in
                
                let rowNum =  self.itemsCollection[indexPath.section]
                let newQty = rowNum.qty + 1
                rowNum.qty = newQty
                
                rowNum.serialNum.append("N/A")

                self.itemsTableView.reloadData()
 
                print(cell)
                print("\(rowNum.itemName) has  these folllowing serial numbers \(rowNum.serialNum)")
                
            }
         
        } else {
            
            
            cell.backgroundColor = .systemGreen
            
            cell.serialLabel.text = itemsCollection[indexPath.section].serialNum[indexPath.row - 1]
            cell.removeQtyBtn.isHidden = true
            cell.addQtyBtn.isHidden = true
            
            
            let rowsCount = self.itemsTableView.numberOfRows(inSection: indexPath.section)
            

            
            
            for row in 1..<rowsCount {
                print(row)
            }
        }
       return cell
        
    }
}



extension MultipleItemsVC: UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        

        
        let selectedItem = itemsCollection[indexPath.section]
        
        let editItem =  UIContextualAction(style: .normal, title: "Edit") {(action,view, nil) in
            
            let alert = UIAlertController(title: "Edit Serial Number in \(selectedItem.itemName)'s ?", message: nil, preferredStyle: .alert)
            
            
            alert.addTextField { (tf) in tf.placeholder = "Serial Num"}
            
            let action = UIAlertAction (title: "Submit",style: .default) { (_) in
               
                if let newSerialNum = alert.textFields?.first?.text {
                    
                    switch (indexPath.section, indexPath.row) {
                    
                    case (0...50,0): selectedItem.serialNum[0] = newSerialNum ; print(" Editing first serial num in array")
                    case (0...50,0...50): selectedItem.serialNum[indexPath.row - 1] = newSerialNum ; print ("Edited other serial numbers other than the first one")
                 
                    default: print("\(String(describing: newSerialNum))") ; print("default in switch for edit serial Num was triggered")
                        
                    }
                    
             
                }

                
                self.itemsTableView.reloadData()
                
              
            }
            
            
            let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
            
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
            print("Done Editing Items")
            
        }
//MARK: - ADD CALANDER/ REDURN DATE TO EDIT ROWS?
//        let dateReturnItem = UIContextualAction(style: .normal, title: "Return Date?") { (action,view, nil) in
//            <#code#>
//        }
//
     
        editItem.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
   
        return UISwipeActionsConfiguration(actions: [editItem])
    }
   
    
    

    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
     
            if itemsCollection[indexPath.section].qty == 1 {
                
                itemsCollection[indexPath.section].isOpened = false
                
                itemsTableView.reloadSections([indexPath.section], with: .fade)
                
                print("No need to expand section \(indexPath.section) but you are at row \([indexPath.row]) at section  \(indexPath.section) ")
                
            } else {
         
                itemsCollection[indexPath.section].isOpened = !itemsCollection[indexPath.section].isOpened
                
//MARK: -  Call CustomTableViewCell to force run the resuse cell here???? !
                
                itemsTableView.reloadSections([indexPath.section], with: .fade)
                
                print("you you selecting Row \([indexPath.row])  at Section \([indexPath.section])" )
                
   
            }
            

        } else {
            
            
            print("Sub Cell was tapped at row\([indexPath.row]) at section \([indexPath.section])  ")

          
        }
    }

        

    
    
    ///Delete single item & it's properties  in array and db.
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
            
            if editingStyle == .delete {
            switch (indexPath.section, indexPath.row){
            
            case (0...50,0): itemsCollection.remove(at: indexPath.section)
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                itemsTableView.deleteSections(indexSet, with: .left)
                self.itemsTableView.reloadData()
                
            case (0...50,0...50): itemsCollection[indexPath.section].serialNum.remove(at: indexPath.row - 1)
                
                print(itemsCollection[indexPath.section].serialNum.count)
           
                
                let selectedSection = itemsCollection[indexPath.section]
                
                let newQty = selectedSection.qty - 1
                
                selectedSection.qty = newQty
                
                print("The new qty for \(selectedSection.itemName)is \(newQty)")
                
                
                itemsTableView.deleteRows(at: [indexPath], with: .left)
                
                self.itemsTableView.reloadData()
//MARK: - Need to fix upating qty number label in section
                
        //        self.itemsTableView.reloadSections(IndexPath.section, with: .fade)
             
                
            default: print("default triggered")
            //   itemsCollection.remove(at: indexPath.section - 1)
                }
            }
            
            
            
        }

 

}



    
 
    

