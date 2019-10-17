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
        
        
      //  self.popOver.layer.cornerRadius = 10
        
        // Setup Database Connection here
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
            let fileUrl = documentDirectory.appendingPathComponent("ItemCheck").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
//
//        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            item.text = item[indexPath.row].item
//            selectedItem = indexPath.row
//        }
//
//        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return item.count
//        }
//
//
//        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")!
//            var label: UILabel
//            label = cell.viewWithTag(1) as! UILabel // Item label
//            label.text = contacts[indexPath.row].name
//
//            label = cell.viewWithTag(2) as! UILabel // Shop/User label
//            label.text = contacts[indexPath.row].phone
//
//            return cell
//        }

        
    }
    
    
    let itemTable2  = Table("ItemCheck2")
    let id = Expression<Int> ("id")
    let item = Expression<String> ("item")
    let assignedTo = Expression<String>("assignedTo")
    let staff = Expression<String>("staff")
    let serial = Expression<String>("serial")
    let timecheck = Expression<String>("date")
    

    //Create a Table here and then check to make sure it does not already exist
        
    @IBAction func createTableBtn(_ sender: UIButton) {
//
//    I have disabled the createTabe Button here in case someone presses it but we should create a button that deletes the old table and creates a new one to refresh the ID number for the month
//
//        let createTable = self.itemTable2.create {(table) in
//            table.column(self.id, primaryKey: true)
//            table.column(self.item)
//            table.column(self.assignedTo)
//            table.column(self.staff)
//            table.column(self.serial)
//            table.column(self.timecheck)
//        }
//        do {
//            try self.database.run(createTable)
//            print ("Created Table")
//
//        }  catch {
//            print (error)
//        }

    }
    
    
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
        let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })
        
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert,animated: true,completion: nil)
        
    }
// ---------- Clear All Items in Table ------  //
    
    
    @IBAction func clearAll(_ sender: UIButton) {
        
        print ("ALL USERS CLEARED")
        let alert = UIAlertController(title: "Delet All Records?", message:nil, preferredStyle: .alert )
        
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

    //-------------------Export the file here------------//
    
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
    // lines with popOver is needed for iPAD_ remove it if it does not work with iphone
                  if let popOver = vc.popoverPresentationController {
                      popOver.sourceView = self.view
              
                  
                      
                  }
                  
                  
                  
                  //-----
                  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
                      controller.dismiss(animated: true, completion: nil)
                  }
              } catch {
                  print(error)
                  print ("Error: Failed to create")
              }
          }
      } catch {
          print(error)
      }
      
// Print out to copy/pasta - work around (below)
//    do {
//        let records = try self.database.prepare(self.itemTable2)
//
//
//        for record in records {
//
//        let exportString = "\(record[self.id]) , \(record[self.item ]) , \(record[self.assignedTo]) , \(record[self.staff]), \(record[self.serial]), \(record[self.timecheck]) \n"
//
//            print(exportString)
//
//    }
//
//    } catch {
//        print (error)
//    }

    // Print out to copy/pasta - work around (above)
    
}
            
//             let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//
//            let exportString = [String] (arrayLiteral:"logID,item,assignedTo,staff,serial,date\r\n","\(record[self.id])" , (record[self.item ]) , (record[self.assignedTo]) , (record[self.staff]), (record[self.serial]) , (record[self.timecheck]) )
//
//            let inputString = exportString.joined(separator: ",")
//
//            let data = inputString.data (using: String.Encoding.utf8, allowLossyConversion: false )
//

        
            // let content = data   {
            
            
            //    print ("NSData: \(content)")
            //----
            
            //---- Added this line
            //                if MFMailComposeViewController.canSendMail() {
            //                    let emailController = MFMailComposeViewController()
            //                    emailController.mailComposeDelegate = self
            //                    emailController.setToRecipients(["info@canzino.com"])
            //                    emailController.setSubject("Exported Shit")
            //                    emailController.setMessageBody("You are an app developer, padwan", isHTML: false)
            //                    emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "text/csv", fileName: fileName)
            //
            //                }
            //------
        

//        }
   
    
}

//        let inputString = exportString.joined(separator: ",")
//     let data = inputString.data (using: String.Encoding.utf8, allowLossyConversion: false )
    


