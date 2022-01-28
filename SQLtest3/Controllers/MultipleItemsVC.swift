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
        
        self.title = "Add Items"
        
  /// You do not need the code below when using cutomTabelviewCell file, it will just break!
// self.itemsTableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let item1 = ItemForMulti(itemName: "SexBox", serialNum: "N/A", qty: 1)
    //    itemsTest.append(item1)
        itemsCollection.append(item1)
    }
    
    
    public var itemsTest = [String]()
    
    
    public var itemsCollection = [ItemForMulti]()


    
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    
    
    
    @IBAction func addItemBtn(_ sender: Any) {
        
        // Fix Alert? and figure out how to add new item into itemsTest array here
        
        let alert = UIAlertController(title: "Add New Item!", message: "", preferredStyle: .alert)
        
        alert.addTextField { (itemName) in
            itemName.placeholder = "Add New Item Here"
        }
        
        alert.addTextField { (itemName) in
            itemName.placeholder = "Serail Num"
        }
        
      
        
        let action = UIAlertAction(title: "Ok", style: .default) {(_) in
            guard let item = alert.textFields?.first?.text else {return}
            guard let serial = alert.textFields?.last?.text else {return}
        
            let newObject = ItemForMulti(itemName: item, serialNum: serial,qty:1)
            
//              let newObject2 = ItemForMulti()
            
//           self.itemsTest.append(item)
//            self.itemsTest.append(serial)
//            self.itemsTableView.reloadData()
            
            self.add(newObject)
            print(newObject)
      
        
        }
        let cancel = UIAlertAction(title:"Cancel",style: .destructive,handler:{(action) -> Void in })

        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
        print(itemsCollection)
        
        
        
        
    }

    
    func add(_ newObject: ItemForMulti) {
        
       let index = 0
        itemsCollection.insert(newObject, at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        
        itemsTableView.insertRows(at: [indexPath], with: .left)
        
   
        
   //     itemsCollection.insertRows(at: [indexPath], with: .fade)
    }

 
   @objc func addQtyBtnTapped(sender:UIButton){
        
    let rowIdex:Int = sender.tag
    
        //Do something with data of the rowIndex
    print(rowIdex)
    
    }
                         
                         


    
   
}

extension MultipleItemsVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.itemNameLabel.text = itemsCollection[indexPath.row].itemName
        cell.serialLabel.text = itemsCollection[indexPath.row].serialNum
        cell.qtyLabel.text = "Qty:"
        cell.qtyNum.text = "\(itemsCollection[indexPath.row].qty)"
        
        
        cell.addQtyBtn.tag = indexPath.row
        cell.addQtyBtn.addTarget(self, action: #selector(addQtyBtnTapped(sender:)), for: .touchUpInside)
        
        
//        let qtyInDetailCell = itemsCollection[indexPath.row].qty

//        cell.detailTextLabel?.text = itemsCollection[indexPath.row].serialNum

//        cell.textLabel?.text = itemsCollection[indexPath.row].itemName + " Qty: \(qtyInDetailCell)"


        return cell
    }
   
   
    
    
}
    
extension MultipleItemsVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title:"\(itemsCollection[indexPath.row].itemName)", message: " Has a qty of \(itemsCollection[indexPath.row].qty)" , preferredStyle: .alert )

        let action = UIAlertAction(title:"Done",style: .default) { (_) in

        }

        alert.addAction(action)
        present(alert,animated: true ,completion: nil)
    }
    
}
    
 
/// Use this if you are
class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    

