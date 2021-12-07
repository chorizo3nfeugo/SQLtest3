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

final class ConfigView: UIViewController,MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate {
   
    
    var database:Connection!

override func viewDidLoad() {
            super.viewDidLoad()
            
            if #available(iOS 13.0, *) {
                view.backgroundColor = .systemBackground
            } else {
                
            }
            exportBtn.layer.cornerRadius = 6
            clearAllBtn.layer.cornerRadius = 6
            
            do {
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
                let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
                let database = try Connection(fileUrl.path)
                self.database = database
            } catch {
                print(error)
            }
            
            func getRows() -> Array<ItemContainter> {
                do {
                    let records = try self.database.prepare(self.itemTable2.order(id.desc))
                    for record in records {
                        
                        checkOutItemsArray.append(ItemContainter(idNum: record[self.id], itemName: "\(record[self.item])", assigned: "\(record[self.assignedTo])", staff: "\(record[self.staff])", timeCheck: "\(record[self.timecheck])",serialNum: "\(record[self.serial])"))
                    }
                    print(checkOutItemsArray.count)
                } catch {
                    print(error)
                }
                return checkOutItemsArray
            }
            print(getRows())
        
        }
    
//Database properties
    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
    
   
    
 /// Once database has been loaded this array will hold all db data temporarly to display for tableview
    
    var checkOutItemsArray:[ItemContainter] = []
    
    
    
/// Setup table view for thie viewController
    @IBOutlet weak var itemListTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkOutItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = checkOutItemsArray[indexPath.row].itemName
        cell.detailTextLabel?.text = checkOutItemsArray[indexPath.row].assigned

        return cell
    }

    
///Delete single item & it's properties  in array and db.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

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
  
  
    

    /// Following right swipe here update assignee and / or serial num
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
                        let selectedItem = self.checkOutItemsArray[indexPath.row].itemName
                        
                        let editItem =  UIContextualAction(style: .normal, title: "Edit") {(action,view, nil) in
                            
                        let alert = UIAlertController(title: "Update \(selectedItem)", message: nil, preferredStyle: .alert)
                         
                          alert.addTextField { (tf) in tf.placeholder = "Assignee"}
                          alert.addTextField { (tf) in tf.placeholder = "Serial"}
                         
                            let action = UIAlertAction (title: "Submit",style: .default) { (_) in
                            
                            let itemIdString = self.checkOutItemsArray[indexPath.row].idNum
                            let itemName = self.checkOutItemsArray[indexPath.row].itemName
                            let selectedItem = self.itemTable2.filter(self.id == itemIdString)
                            
                            let assignedTo = alert.textFields?.first?.text
                            let updateAssignee = selectedItem.update(self.assignedTo <- assignedTo!)
  
                            let serialNum = alert.textFields?.last?.text
                            let updateSerial = selectedItem.update(self.serial <- serialNum!)
    
                                
                                if assignedTo!.isEmpty && serialNum!.isEmpty {
                                    Alert.showBasic(title: "Whoops!", message: "Please Input New Assignee Or Serial Number To Update!", vc: self)
                                }
                                
                                if assignedTo!.isEmpty && !serialNum!.isEmpty {
                                    do {
                                       try self.database.run(updateSerial)
                                        Alert.showBasic(title: "\(itemName) Updated!", message: "Serial Num Updated!", vc: self)
                                    } catch {
                                        print(error)
                                    }
                                }
                                if serialNum!.isEmpty && !assignedTo!.isEmpty {
                                    do {
                                        try self.database.run(updateAssignee)
                                        Alert.showBasic(title: "\(itemName) Updated!", message: "Updated Assignee!", vc: self)
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                                if !serialNum!.isEmpty && !assignedTo!.isEmpty {
                                    do {
                                            try self.database.run(updateAssignee)
                                            try self.database.run(updateSerial)
                                        print("Updating Assignee and Serial num!")
                                        Alert.showBasic(title: "Item Updated!", message: "Assignee and Serial Num Updated!", vc: self)
                                            } catch  {
                                                print (error)
                                    }
                                }
                self.checkOutItemsArray.removeAll()
                self.viewDidLoad()

        DispatchQueue.main.async { self.itemListTableView.reloadData() }
                                
                     // Closing bracket for Edit Actions
                          }
                            

                let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
                          alert.addAction(action)
                          alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
                 
            print("Done Editing Items")
        }
        
        editItem.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return UISwipeActionsConfiguration(actions: [editItem])
        
   ///Closing bracked for update swiped!
    }
        
    
    
///Date Converter function
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM-dd-yyyy HH:mm"
        return  dateFormatter.string(from: date!)

    }

///Shows details of item when selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let selectedDate = (self.checkOutItemsArray[indexPath.row].timeCheck)
///Convert Date here to better format for display
       let convertedDate  =  convertDateFormater(selectedDate)
        
        let alert = UIAlertController(title:"\(checkOutItemsArray[indexPath.row].itemName)", message: " Has Been Assigned To \(checkOutItemsArray[indexPath.row].assigned). With Serial Number \(checkOutItemsArray[indexPath.row].serialNum).   Checked Out By \(checkOutItemsArray[indexPath.row].staff) On \(convertedDate)" , preferredStyle: .alert )
        
        let action = UIAlertAction(title:"Done",style: .default) { (_) in
            
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }

    
/// This clears all items in database
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBAction func clearAll(_ sender: UIButton) {
        
    let alert = UIAlertController(title: "Delete All Records?", message:nil, preferredStyle: .alert )
        
    let submit = UIAlertAction(title:"Yes", style:.default){
            ACTION in clearData().self
        }
        
        let cancel = UIAlertAction(title:"No",style: .destructive,handler:{(action) -> Void in })
        
        
  /// The following function deletes all items in database and clears out temporary array of checkOutItems
        func clearData(){
            let deleteAll = self.itemTable2.delete()
            do {
                try self.database.run(deleteAll)
                print("All items have been deleted!")
                performSegue(withIdentifier: "backToMainVC", sender: self)
            } catch {
                print (error)
            }
       
        }
        alert.addAction(submit)
        alert.addAction(cancel)
        present(alert,animated: true,completion: nil)
       
    }
    
/// This changes dataBaseDeleted  variable on main viewController to true. This is triggered after user confirms to delete all items in clearAllBtn button function.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMainVC"{
            if let destVC = segue.destination as? ViewController  {
                destVC.dataBaseDeleted = true
            }
        }
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



