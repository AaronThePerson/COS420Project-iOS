//
//  Shift.swift
//  Payrr
//
//  Created by Aaron Speakman on 4/2/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Shift: NSObject{
    struct ShiftJSONData: Encodable{
        let job_id: String
        let employee_id: String
        let shift_number: Int
        let date: String?
        let start: String?
        let end: String?
        let quantity: String?
        let commission: String?
        
        init(jobId: String, employeeID: String, shiftNumber: Int, date: String, quantity: String) {
            self.job_id = jobId
            self.employee_id = employeeID
            self.shift_number = shiftNumber
            self.date = date
            self.quantity = quantity
            self.start = nil
            self.end = nil
            self.commission = nil
        }
        
        init(jobId: String, employeeID: String, shiftNumber: Int, date: String, quantity: String, commission: String) {
            self.job_id = jobId
            self.employee_id = employeeID
            self.shift_number = shiftNumber
            self.date = date
            self.quantity = quantity
            self.commission = nil
            self.start = nil
            self.end = nil
        }
        
        init(jobId: String, employeeID: String, shiftNumber: Int, start: String, end: String, date: String) {
            self.job_id = jobId
            self.employee_id = employeeID
            self.shift_number = shiftNumber
            self.start = start
            self.end = end
            self.date = date
            self.quantity = nil
            self.commission = nil
        }
        
        init(jobId: String, employeeID: String, shiftNumber: Int, start: String, end: String, commission: String, date: String) {
            self.job_id = jobId
            self.employee_id = employeeID
            self.shift_number = shiftNumber
            self.start = start
            self.end = end
            self.commission = nil
            self.date = date
            self.quantity = nil
        }
    }
    
    var job: Job
    var employeeID: String
    var shiftNumber: Int?
    var entryType: Bool
    var startTime: Date?
    var endTime: Date?
    var date: Date?
    var duration: Date?
    var commission: String?
    
    var startTimeText: String?
    var endTimeText: String?
    var dateText: String?
    var durationText: String?
    
    init(job: Job, entryType: Bool, employeeID: String) {
        self.job = job
        self.entryType = entryType
        self.employeeID = employeeID
    }
    
    func getJSONEncoded()->[String: Any]{
        
        let dateFormatter = DateFormatter()
        let startEndFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        startEndFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "HH:mm:ss"
        
        var commissionEdited: String?
        
        if self.commission != nil{
            commissionEdited = (self.commission?.trimmingCharacters(in: CharacterSet.symbols))!
            commissionEdited = commissionEdited?.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        var durationJSONString: String
        if durationText == "All Day" || self.duration == nil{
            durationJSONString = "24"
        }
        else{
            let calendar = Calendar.current
            let hours: Double = Double(calendar.component(.hour, from: self.duration!))
            let minutes: Double = Double(calendar.component(.minute, from: self.duration!))
            let hourMin = hours + (minutes/60)
            durationJSONString = String(format: "%5f", hourMin)
        }
        
        var shift: ShiftJSONData?
        
        if self.entryType == true{
            if self.commission != nil{
                shift = ShiftJSONData(jobId: self.job.jobID, employeeID: self.employeeID, shiftNumber: self.shiftNumber!, start: startEndFormatter.string(from: self.startTime!), end: startEndFormatter.string(from: self.endTime!), commission: commissionEdited!, date: dateFormatter.string(from: self.startTime!))
            }
            else{
                shift = ShiftJSONData(jobId: self.job.jobID, employeeID: self.employeeID, shiftNumber: self.shiftNumber!, start: startEndFormatter.string(from: self.startTime!), end: startEndFormatter.string(from: self.endTime!), date: dateFormatter.string(from: self.startTime!))
            }
        }
        else{
            //quantity is actually hour duration
            if self.commission != nil{
                shift = ShiftJSONData(jobId: self.job.jobID, employeeID: self.employeeID, shiftNumber: self.shiftNumber!, date: dateFormatter.string(from: self.date!), quantity: durationJSONString, commission: commissionEdited!)
            }
            else{
                shift = ShiftJSONData(jobId: self.job.jobID, employeeID: self.employeeID, shiftNumber: self.shiftNumber!, date: dateFormatter.string(from: self.date!), quantity: durationJSONString)
            }
        }
        
        var dict: [String: Any] = [:]
        
        if entryType == true{
            dict = ["shift_number": shift?.shift_number as Any, "date": shift?.date as Any, "start": shift?.start as Any, "end": shift?.end as Any, "job_id": shift?.job_id as Any, "employee_id": shift?.employee_id as Any]
        }
        else{
            dict = ["shift_number": shift?.shift_number as Any, "date": shift?.date as Any, "quantity": shift?.quantity as Any, "job_id": shift?.job_id as Any, "employee_id": shift?.employee_id as Any]
        }
    
        return dict
    }
}
