//
//  EmployeesTableViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/19/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class EmployeesTableViewController: UITableViewController{
    
    var token: String?
    
    var employees = [Employee]()
    var selectedEmployee: Employee?
    var myIndex = 0
    var jobs = [Job]()
    
    var employeesCollected: Bool = false
    var jobsCollected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployees { (employeesJSON) in
            self.buildEmployees(employeesJSON: employeesJSON)
            self.employeesCollected = true
            self.employeesHaveJobs()
        }
        getJobs { (jobsJSON) in
            self.buildJobs(jobsJSON: jobsJSON)
            self.jobsCollected = true
            self.employeesHaveJobs()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToHours"){
            let hourEntryController = segue.destination as! HourEntryViewController
            hourEntryController.employee = self.selectedEmployee
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "employeeCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmployeeTableViewCell else{
            fatalError("Cell could not be instantitated")
        }
        
        let employee = employees[indexPath.row]
        
        cell.employeeID.text = "ID: " + employee.id!
        cell.employeeName.text = employee.name
        
        // Configure the cell...
        
        return cell
    }
    @IBAction func logout(_ sender: Any) {
        let loginScreen = storyboard?.instantiateInitialViewController()
        self.present(loginScreen!, animated: true) {
        }
        //performSegue(withIdentifier: "logout", sender: Any.self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEmployee = employees[indexPath.row]
        performSegue(withIdentifier: "goToHours", sender: self)
    }
    
    func getEmployees(completion: @escaping (_ serverResponse: DataResponse<JSON>)->Void){
        let employeesURL: URL = URL(string: "https://umcos420gp.com/server/public/employees")!
        let authHeaders = ["Authorization": "Bearer " + token!] as HTTPHeaders
        Alamofire.request(employeesURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders).responseSwiftyJSON { (response) in
            if response.response?.statusCode == 200{
                //print(response)
                completion(response)
            }
        }
    }
    
    func buildEmployees(employeesJSON: DataResponse<JSON>){
        let employeesData = JSON(employeesJSON.result.value!)
        let employeesArray = employeesData.array
        let num: Int = (employeesArray?.count)!
        
        for i in 0..<num {
            let dict = employeesArray?[i].dictionaryValue
            
            let firstName: String = (dict?["firstname"]!.stringValue)!
            let middleName: String = (dict?["middlename"]!.stringValue)!
            let lastName: String = (dict?["lastname"]!.stringValue)!
            
            let employeeID: String = (dict?["employee_id"]!.stringValue)!
            var name: String = ""
            
            if middleName != ""{
                name = firstName + " " + middleName + " " + lastName
            }
            else{
                name = firstName + " " + lastName
            }
            
            let someEmployee = Employee(name: name, id: employeeID)
            employees.append(someEmployee)
        }
    }
    
    func getJobs(completion: @escaping (_ serverResponse: DataResponse<JSON>)->Void){
        let employeesURL: URL = URL(string: "https://umcos420gp.com/server/public/jobs")!
        let authHeaders = ["Authorization": "Bearer " + token!] as HTTPHeaders
        Alamofire.request(employeesURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders).responseSwiftyJSON { (response) in
            if response.response?.statusCode == 200{
                completion(response)
            }
        }
    }
    
    func buildJobs(jobsJSON: DataResponse<JSON>){
        let jobsData = JSON(jobsJSON.result.value!)
        let jobsArray = jobsData.array
        let num: Int = (jobsArray?.count)!
        
        for i in 0..<num {
            let dict = jobsArray?[i].dictionaryValue
            
            let jobName: String = (dict?["title"]!.stringValue)!
            let jobID: String = (dict?["job_id"]!.stringValue)!
            
            let someJob = Job(jobName: jobName, jobID: jobID)
            jobs.append(someJob)
        }
    }
    
    func employeesHaveJobs(){
        if employeesCollected && jobsCollected{
            for i in 0..<employees.count{
                employees[i].jobs = jobs
            }
            tableView.reloadData()
        }
    }
    
}
