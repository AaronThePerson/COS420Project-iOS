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
    var jobID: String
    
    init(jobName: String, jobID: String) {
        self.jobName = jobName
        self.jobID = jobID
    }
}
