//
//  SendPayrollViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/5/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit

class SendPayrollViewController: UIViewController {
    
    @IBOutlet weak var shiftWriteOut: UITextView!
    
    var shiftsToAdd: [Shift]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showShifts()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        //performSegue(withIdentifier: "submittedHours", sender: Any?.self)
    }
    
    func showShifts(){
        var outputText: String = "Shifts To Add \n"
        
        for i in 0..<shiftsToAdd!.count{
            outputText.append("\nShift " + String(i+1))
            outputText.append("\nJob: " + (shiftsToAdd?[i].job.jobName)!)
            if shiftsToAdd?[i].entryType == true{
                outputText.append("\nStart Time: " + (shiftsToAdd?[i].startTimeText)!)
                outputText.append("\nEnd Time: " + (shiftsToAdd?[i].endTimeText)!)
            }
            else{
                outputText.append("\nDate: " + (shiftsToAdd?[i].dateText)!)
                outputText.append("\nDuration: " + (shiftsToAdd?[i].durationText)!)
            }
            if shiftsToAdd?[i].commission != nil{
                outputText.append("\nTips/Comission: " + (shiftsToAdd?[i].commission)!)
            }
            outputText.append("\n")
            
        }
        shiftWriteOut.text = outputText
    }
    
}
