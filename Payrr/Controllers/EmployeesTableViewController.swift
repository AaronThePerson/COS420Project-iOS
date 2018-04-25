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

class EmployeesTableViewController: UITableViewController{
    
    var token: String?
    
    var employees = [Employee]()
    var selectedEmployee = Employee(name: "test", id: "test", jobs: [Job(jobName: "test", commision: false)!])
    var myIndex = 0
    var jobs = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployees { (employeesJSON) in
            self.buildEmployees(employeesJSON: employeesJSON)
        }
        loadSampleEmployees()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    private func loadSampleEmployees(){
        let job1 = Job(jobName: "Job1", commision: true)
        let job2 = Job(jobName: "Job2", commision: false)
        
        var testJobs = [Job]()
        testJobs.append(job1!)
        testJobs.append(job2!)
        
        guard let employee1 = Employee(name: "Aaron Speakman", id: "12ADT53", jobs: testJobs) else{
            fatalError("Cannot create employee")
        }
        guard let employee2 = Employee(name: "Justin Norman", id: "3132BD4", jobs: testJobs) else{
            fatalError("Cannot create employee")
        }
        guard let employee3 = Employee(name: "Jovon Craig", id: "546GD2Q", jobs: testJobs) else{
            fatalError("Cannot create employee")
        }
        guard let employee4 = Employee(name: "Tim Bruce", id: "DA57643", jobs: testJobs) else{
            fatalError("Cannot create employee")
        }
        guard let employee5 = Employee(name: "Tim Thomas", id: "GH433DS", jobs: testJobs) else{
            fatalError("Cannot create employee")
        }
        guard let employee6 = Employee(name: "Patrick Pettegrow", id: "83HDI74", jobs: testJobs) else{
            fatalError("Cannot create employee")
        }
        
        employees += [employee1, employee2, employee3, employee4, employee5, employee6]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEmployee = employees[indexPath.row]
        performSegue(withIdentifier: "goToHours", sender: self)
    }
    
    func getEmployees(completion: @escaping (_ serverResponse: DataResponse<Any>)->Void){
        
        let employeesURL: URL = URL(string: "https://umcos420gp.com/server/public/employees")!
        let authHeaders = ["Authorization": "Bearer " + token!] as HTTPHeaders
        Alamofire.request(employeesURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: authHeaders).responseJSON { (response) in
            if response.response?.statusCode == 200{
                
                print(response)
                
                completion(response)
            }
        }
    }
    
    func buildEmployees(employeesJSON: DataResponse<Any>){
        struct EmployeeInfo: Decodable {
            let id: String
            let firstname: String
            let middlename: String
            let lastname: String
            
            enum CodingKeys: String, CodingKey{
                case id = "employee_id"
                case firstname
                case middlename
                case lastname
            }
        }
        
        
    }
}
