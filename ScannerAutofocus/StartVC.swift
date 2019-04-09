//
//  StartVC.swift
//  ScannerAutofocus
//
//  Created by Thomas Haider on 16.12.18.
//  Copyright © 2018 Totta Gmbh. All rights reserved.
//
// Modification for Git Hub

import UIKit

class StartVC: UIViewController {
    
    @ IBAction func didPressScan() {
        performSegue(withIdentifier: "StartScan1Segue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


