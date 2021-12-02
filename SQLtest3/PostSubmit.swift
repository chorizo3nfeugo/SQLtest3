//
//  PostSubmit.swift
//  SQLtest3
//
//  Created by zeus on 2019-02-28.
//  Copyright © 2019 zeus. All rights reserved.
//

import Foundation
import UIKit

class Postsubmition: UIViewController {
    
   
  /// This just hides the back button since we dont want the user to put in multuple instances of the same item very easilly. 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
                   view.backgroundColor = .systemBackground
               } else {
                   
               }
               
        
        returnHomeBtn.layer.cornerRadius = 5
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
    }
    
    @IBOutlet weak var returnHomeBtn: UIButton!
    
    
    
}
