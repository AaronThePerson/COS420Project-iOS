//
//  Employee.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/19/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit
import Foundation

class Employee: NSObject{
    
    var name: String?
    var id: String?
    var employerEmployeeID: String?
    var jobs: [Job]?
    
    init(name: String, id: String, employerEmployeeID: String) {
        self.name = name
        self.id = id
        self.employerEmployeeID = employerEmployeeID
    }
    
    init(name: String, id: String, employerEmployeeID: String, jobs: [Job]) {
        self.name = name
        self.id = id
        self.jobs = jobs
        self.employerEmployeeID = employerEmployeeID
    }
    
}



