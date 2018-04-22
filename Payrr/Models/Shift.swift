//
//  Shift.swift
//  Payrr
//
//  Created by Aaron Speakman on 4/2/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import Foundation

class Shift: NSObject{
    var jobTitle: String
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
    
    init(jobTitle: String, entryType: Bool) {
        self.jobTitle = jobTitle
        self.entryType = entryType
    }
    
}
