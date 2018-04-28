//
//  SendPayrollViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/5/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SendPayrollViewController: UIViewController {
    
    @IBOutlet weak var shiftWriteOut: UITextView!
    
    var token: String?
    var maxShift: Int = 0
    
    var shiftsToAdd: [Shift]?
    var shiftJSONParams: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showShifts()
        getHours { (response) in
            self.getMaxShiftID(hoursJSON: response)
            self.writeJSON()
        }
    }
    
    @IBAction func acceptButton(_ sender: Any) {
        for i in 0..<self.shiftJSONParams.count{
            self.postHours(json: self.shiftJSONParams[i], completion: { () in
            })
        }
        self.navigationController?.popToRootViewController(animated: true)
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
    
    func writeJSON(){
        let num: Int = (shiftsToAdd?.count)!
        for shift in 0..<num {
            shiftJSONParams.append((shiftsToAdd?[shift].getJSONEncoded())!)
        }
    }
    
    func getHours(completion: @escaping (_ serverResponse: DataResponse<JSON>)->Void){
        let authHeaders = ["Authorization": "Bearer " + token!] as HTTPHeaders
        Alamofire.request(URL(string: "https://umcos420gp.com/server/public/hours")!, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders).responseSwiftyJSON { (response) in
            if response.response?.statusCode == 200{
                completion(response)
            }
        }
    }
    
    func getMaxShiftID(hoursJSON: DataResponse<JSON>){
        let hoursData = JSON(hoursJSON.result.value!)
        let hoursArray = hoursData.array
        let num: Int = (hoursArray?.count)!
        
        for i in 0..<num {
            let dict = hoursArray?[i].dictionaryValue
            
            let shiftNum: String = (dict?["shift_number"]!.stringValue)!
            let attemptMax = Int(shiftNum)
            if self.maxShift < attemptMax!{
                self.maxShift = attemptMax!
            }
        }
        let shiftNum: Int = (self.shiftsToAdd?.count)!
        for i in 0..<shiftNum{
            self.shiftsToAdd![i].shiftNumber = (i + 1) + maxShift
        }
    }
    
    func postHours(json: [String: Any], completion: @escaping ()->Void){
        let hoursURLString: String = "https://umcos420gp.com/server/public/hours"
        let authHeaders = ["Authorization": "Bearer " + token!, "Content-Type": "application/json"] as HTTPHeaders
        let hoursURL: URL = URL(string: hoursURLString)!
    
        print(json)
        
        Alamofire.request(hoursURL, method: HTTPMethod.post, parameters: json, encoding: JSONEncoding.default, headers: authHeaders).responseJSON { (response) in
            print(response)
            completion()
        }
    }
    
    
    
}
