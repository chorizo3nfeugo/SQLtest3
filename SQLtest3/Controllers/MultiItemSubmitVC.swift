//
//  MultiItemSubmitVC.swift
//  SQLtest3
//
//  Created by zeus on 2022-02-28.
//  Copyright © 2022 zeus. All rights reserved.
//

import UIKit

class MultiItemSubmitVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Submit Items"
        submitBtnView.layer.cornerRadius = 6
        
        
        //MARK: - Open SQLite Database here and start prepping items for sql objects
        
    }
    

    @IBOutlet weak var submitBtnView: UIButton!
    @IBAction func submitBtn(_ sender: Any) {
    }
    // MARK: - Add return Date per item and then show UItext which triggers Calander Selection
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
