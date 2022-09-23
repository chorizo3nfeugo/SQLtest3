//
//  PostSubmit.swift
//  SQLtest3
//
//  Created by zeus on 2019-02-28.
//  Copyright © 2019 zeus. All rights reserved.
//

import Foundation
import UIKit

final class Postsubmition: UIViewController {
    
   
    
// MARK: - ViewDidLoad
   
    var finalLabelText = "Item Submitted & Saved!"
    var titleLabelText = "Item Submitted!"
    
    override func viewDidLoad() {
        
        self.title = titleLabelText
        itemCheckLabel.text = finalLabelText
        
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                   view.backgroundColor = .systemBackground
               } else {
                   
               }
               
        returnHomeBtn.layer.cornerRadius = 6
        returnHomeBtn.clipsToBounds = true
        itemCheckLabel.clipsToBounds = true
        itemCheckLabel.layer.cornerRadius = 6
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        
    }
    
    @IBOutlet weak var returnHomeBtn: UIButton!
    
    
    @IBOutlet weak var itemCheckLabel: UILabel!
    
}
