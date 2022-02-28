//
//  CustomTableViewCell.swift
//  SQLtest3
//
//  Created by zeus on 2022-01-28.
//  Copyright © 2022 zeus. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func prepareForReuse() {
        itemNameLabel.text = nil
        serialLabel.text = nil
        qtyNum.text = nil
        qtyLabel.text = nil
        
        
        
//        addQtyBtn.isHidden = nil
//        removeQtyBtn.isHidden = nil
        
        
    }
    
    
    var removeQtyTapped:((UITableViewCell) -> Void)?
   
    var addQtyTapped:((UITableViewCell) -> Void)?
 
    
    @IBOutlet weak var addQtyBtn: UIButton!
    
    @IBAction func addQty(_ sender: Any) {
        
        addQtyTapped?(self)
        
        print("Add Qty Button Tapped!")
        
    }
    
    @IBOutlet weak var removeQtyBtn: UIButton!
    @IBAction func removeQty(_ sender: Any) {
        
        
        removeQtyTapped?(self)
        
        print("Remove Qty Button Tapped ! ")
     
    
      
    }
    
   
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var qtyNum: UILabel!
    
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var serialLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
