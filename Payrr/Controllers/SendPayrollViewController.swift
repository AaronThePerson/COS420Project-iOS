//
//  SendPayrollViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/5/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit

class SendPayrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func declineButton(_ sender: Any) {
        performSegue(withIdentifier: "editHours", sender: Any?.self)
    }
    
    @IBAction func acceptButton(_ sender: Any) {
        performSegue(withIdentifier: "submittedHours", sender: Any?.self)
    }
}
