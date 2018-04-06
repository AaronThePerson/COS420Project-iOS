//
//  Job.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/26/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import Foundation

class Job: NSObject{
    var jobName: String
    var commision: Bool
    
    init?(jobName: String, commision: Bool) {
        self.jobName = jobName
        self.commision = commision
    }
}
