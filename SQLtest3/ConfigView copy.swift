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
    func getRows() -> Array<String> {
        var itemArray = [String]()
        do {
            let records = try self.database.prepare(self.itemTable2.order(id.desc))
            for record in records {
                itemArray.append ("ID \(record[self.id]) ) \(record[self.item ])   \(record[self.assignedTo])                     \(record[self.staff])  \(record[self.timecheck])")
            }
        } catch {
            print(error)
        }
        return (itemArray)
    }
    
/// Setup table view for thie viewController
    let cellReuseIdentifier = "cell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRows().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = getRows()[indexPath.row]
        return cell
    }
  
    
    
  
    
var database:Connection!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtn.layer.cornerRadius = 5
        exportBtn.layer.cornerRadius = 5
        deleteItmBtn.layer.cornerRadius = 5
        clearAllBtn.layer.cornerRadius = 5
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
            let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    
    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
    

    @IBOutlet weak var updateBtn: UIButton!
    /// Update the Assigned user of the item.
    @IBAction func updateItems(_ sender: UIButton) {
   
        print("UPDATE TAPPED")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Item Id"}
        alert.addTextField { (tf) in tf.placeholder = "AssignedTo"}
        let action = UIAlertAction (title: "Submit",style: .default) { (_) in
       
          guard let itemIdString = alert.textFields?.first?.text,
                
            let itemId = Int(itemIdString),
            let assignedTo = alert.textFields?.last?.text
            
            else { return }
            
            print(itemIdString)
           print(assignedTo)
            
            let assigneee = self.itemTable2.filter(self.id == itemId)
            
            let updateAssignee = assigneee.update(self.assignedTo <- assignedTo)
            
            do {
                try self.database.run(updateAssignee)
            } catch {
                print (error)
            }
        }
        
        ///Create the submit and cancel buttons here
        let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

        
    }
    
    @IBOutlet weak var deleteItmBtn: UIButton!
    
/// This button deletes the item using the ID code
    @IBAction func deleteItem(_ sender: UIButton) {
    
        print ("DELETE TAPPED")
        let alert = UIAlertController(title: "Delete item", message:nil, preferredStyle: .alert )
        alert.addTextField {(tf) in tf.placeholder = "Item ID" }
        let action = UIAlertAction(title:"Submit",style: .default) { (_) in
            guard let itemIDString = alert.textFields?.first?.text,
                let itemId = Int(itemIDString)
                else {return}
            print (itemIDString)
            
            let item = self.itemTable2.filter(self.id == itemId)
            let deleteItem = item.delete()
            do {
                try self.database.run(deleteItem)
            } catch {
                print(error)
            }
        }
        
        ///Create update and canel button here
        let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert,animated: true,completion: nil)
        
    }
    
    
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
                      emailController.setSubject("Exported Shit")
                      emailController.setToRecipients(["cancino.jesus1@gmail.com"])
                      emailController.setMessageBody("You are an app developer, padwan", isHTML: false)
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
              } catch {
                  print(error)
                  print ("Error: Failed to create")
              }
        }
      }
        catch {
          print(error)
      }
      
    }
            
}




