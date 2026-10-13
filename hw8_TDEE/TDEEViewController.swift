//
//  TDEEViewController.swift
//  hw8_TDEE
//
//  Created by CHIEH-TING HSU on 2026/10/11.
//

import UIKit

class TDEEViewController: UIViewController {
    
    var bmrText = String()

    @IBOutlet weak var bmrLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmrLabel.text = "BMR = \(bmrText)"
    }
}
