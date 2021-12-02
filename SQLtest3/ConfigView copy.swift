//
//  ConfigView.swift
//  SQLite iOS
//
//  Created by zeus on 2019-01-14.
//

import Foundation
import UIKit
import SQLite
import MessageUI

class ConfigView: UIViewController,MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate {
   
    /// This func gets the items from SQLite db table called itemTable2
    
    
    
    var checkOutItemsArray:[ItemContainter] = []
    
//This function grabs SQLite records and assigns to checkOutItemsArray
    
    func getRows() -> Array<ItemContainter> {
    //    var  itemArray = [ItemContainter]()
        do {
            let records = try self.database.prepare(self.itemTable2.order(id.desc))
            for record in records {
                
                checkOutItemsArray.append(ItemContainter(idNum: record[self.id], itemName: "\(record[self.item])", assigned: "\(record[self.assignedTo])", staff: "\(record[self.staff])", timeCheck: "\(record[self.timecheck])",serialNum: "\(record[self.serial])"))
            }
          
    print(checkOutItemsArray)
            
         //   checkOutItemsArray = itemArray
            
        } catch {
            print(error)
        }
        return checkOutItemsArray
    }
    
 
    
    
/// Setup table view for thie viewController
    
    @IBOutlet weak var itemListTableView: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkOutItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = checkOutItemsArray[indexPath.row].itemName
        cell.detailTextLabel?.text = checkOutItemsArray[indexPath.row].assigned
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

// Need to add confirmation pop up?

        
                let itemIDString = checkOutItemsArray[indexPath.row].idNum
                let itemID = Int(itemIDString)

               let item = self.itemTable2.filter(self.id == itemID)
               let deleteItem = item.delete()
               do {
                   try self.database.run(deleteItem)
                print("All items at \(itemID) has been deleted ")
               } catch {
                   print(error)
               }

            guard editingStyle == .delete else {return}
        
        checkOutItemsArray.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        self.itemListTableView.reloadData()
        
    }
  
  
    
    
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                print("UPDATE TAPPED")
             
                        let selectedItem = self.checkOutItemsArray[indexPath.row].itemName
                        
                        let editItem =  UIContextualAction(style: .normal, title: "Edit") {(action,view, nil) in
                            
                        let alert = UIAlertController(title: "Update \(selectedItem)", message: nil, preferredStyle: .alert)
                         
                          alert.addTextField { (tf) in tf.placeholder = "Assigned To"}
                          alert.addTextField { (tf) in tf.placeholder = "Serial"}
                         
                            let action = UIAlertAction (title: "Submit",style: .default) { (_) in
            
                            let itemIdString = self.checkOutItemsArray[indexPath.row].idNum
                            let selectedItem = self.itemTable2.filter(self.id == itemIdString)
                            
                            let assignedTo = alert.textFields?.first?.text
                            let updateAssignee = selectedItem.update(self.assignedTo <- assignedTo!)
  
                //   Need to call this in another do catch block? or
                            let serialNum = alert.textFields?.last?.text
                            let updateSerial = selectedItem.update(self.serial <- serialNum!)
                //
                              
                            if assignedTo!.isEmpty && serialNum!.isEmpty {
                                Alert.showBasic(title: "No data to update!", message: "Please fill out Assigned To or Serial Num!", vc: self)
                            }

                                if assignedTo!.isEmpty {
                                    do {
                                        try self.database.run(updateSerial)
                                        Alert.showBasic(title: "Item Updated", message: "Serial Num Updated!", vc: self)
                                    } catch {
                                        print(error)
                                    }
                                }

                                if serialNum!.isEmpty {
                                    do {
                                        try self.database.run(updateAssignee)
                                        Alert.showBasic(title: "Item Updated!", message: "Updated Assigned To!", vc: self)
                                    } catch {
                                        print(error)
                                    }
                                }

                                if !serialNum!.isEmpty && !assignedTo!.isEmpty {
                                    do {
                                            try self.database.run(updateAssignee)
                                            try self.database.run(updateSerial)

                                        Alert.showBasic(title: "Item Updated!", message: "Assigned To and Serial Num Updated!", vc: self)

                                            } catch  {

                                                print (error)
                                                }
                                }
     
                      // Closign bracket for actions
                          }
    ///Create the submit and cancel buttons here
                          let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
                          alert.addAction(action)
                          alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
                 
            print("Done Editing Items")
        }
/// This should udpdate the row here... not sure where to slap it in?

        editItem.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return UISwipeActionsConfiguration(actions: [editItem])
    }
        
    
    
//Date Converter
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM-dd-yyyy HH:mm"
        return  dateFormatter.string(from: date!)

    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let selectedDate = (self.checkOutItemsArray[indexPath.row].timeCheck)
//Convert Date here to better format
       let convertedDate  =  convertDateFormater(selectedDate)
        
// Setting constant to display details of selected Item
        let alert = UIAlertController(title:"\(checkOutItemsArray[indexPath.row].itemName)", message: "with Serial Number \(checkOutItemsArray[indexPath.row].serialNum) has been assigned to \(checkOutItemsArray[indexPath.row].assigned) & signed out by \(checkOutItemsArray[indexPath.row].staff) on \(convertedDate)" , preferredStyle: .alert )
        
       
        
        let action = UIAlertAction(title:"Done",style: .default) { (_) in
         
            
            
        }
        
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    }


    
var database:Connection!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            
        }
        
        
     //   updateBtn.layer.cornerRadius = 5
        exportBtn.layer.cornerRadius = 5
    //    deleteItmBtn.layer.cornerRadius = 5
        clearAllBtn.layer.cornerRadius = 5
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
            let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        print(getRows())
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.itemListTableView.reloadData()
//    }
    
    
    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
    
/// This clears all items in database table
    @IBOutlet weak var clearAllBtn: UIButton!
    
    @IBAction func clearAll(_ sender: UIButton) {
        
        print ("ALL USERS CLEARED")
        let alert = UIAlertController(title: "Delete All Records?", message:nil, preferredStyle: .alert )
        
        let submit = UIAlertAction(title:"Yes", style:.default){
            ACTION in clearData().self
        }
        
        let cancel = UIAlertAction(title:"No",style: .destructive,handler:{(action) -> Void in })
        
        func clearData(){
            let deleteAll = self.itemTable2.delete()
            do {
                try self.database.run(deleteAll)
            } catch {
                print (error)
            }
        }
        alert.addAction(submit)
        alert.addAction(cancel)
        present(alert,animated: true,completion: nil)
    }

/// This exports the items in table into a csv file and attaches to an external application within the iOS device
    
    @IBOutlet weak var exportBtn: UIButton!
    
   @IBAction func exportBtn(_ sender: UIButton) {
    do {
          let records = try self.database.prepare(self.itemTable2)
          
          var csvText = "logID,item,assignedTo,staff,serial,date\r\n"
          
          for record in records {
              let fileName = "exportedItems.csv"
              //  let path = P_tmpdir.appending(fileName)
              
              let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

              let exportString = "\(record[self.id]) , \(record[self.item ]) , \(record[self.assignedTo]) , \(record[self.staff]), \(record[self.serial]), \(record[self.timecheck]) \n"
              
              csvText.append(contentsOf: exportString)
              
              let data = csvText.data (using: String.Encoding.utf8, allowLossyConversion: false )
              do {
                  try data?.write(to:path!)
              } catch {
                  print("Failed to create file")
                  print("\(error)")
              }
              if let content = data {
                  print("NSData: \(content)")
                  func configureMailComposeViewController() -> MFMailComposeViewController{
                      let emailController = MFMailComposeViewController()
                      emailController.mailComposeDelegate = self
                      emailController.setSubject("Exported Items")
                      emailController.setToRecipients(["youremail@gmail.com"])
                      emailController.setMessageBody("Here is a list of checked out items!", isHTML: false)
                      //ataching
                      emailController.addAttachmentData(data!, mimeType: "text/csv", fileName: fileName)
                      return emailController
                  }
              }
               do {
                  let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
                  vc.excludedActivityTypes = [
                      UIActivity.ActivityType.assignToContact,
                   ]
                 present(vc, animated: true, completion: nil)
   
                /// lines with popOver is needed for iPAD_ remove it if it does not work with iphone
                  if let popOver = vc.popoverPresentationController {
                      popOver.sourceView = self.view
                  }
                func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
                      controller.dismiss(animated: true, completion: nil)
                  }
              }

        }
    } catch {
        print("Failed to export")
    }
//Closing export Btn bracket
}

//Closing Config ViewController
}

