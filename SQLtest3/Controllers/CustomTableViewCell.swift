//
//  CustomTableViewCell.swift
//  SQLtest3
//
//  Created by zeus on 2022-01-28.
//  Copyright © 2022 zeus. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var addQtyBtn: UIButton!
    
    @IBAction func removeQty(_ sender: Any) {
        
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
