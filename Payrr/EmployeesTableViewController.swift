//
//  EmployeesTableViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/19/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit

class EmployeesTableViewController: UITableViewController {

    var employees = [Employee]()
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleEmployees()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EmployeeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmployeeTableViewCell else{
            fatalError("Cell could not be instantitated")
        }
        
        let employee = employees[indexPath.row]
        
        cell.employeeID.text = "ID: " + employee.id
        cell.employeeName.text = employee.name
        
        // Configure the cell...
        
        return cell
    }
    
    private func loadSampleEmployees(){
        guard let employee1 = Employee(name: "Aaron Speakman", id: "12ADT53") else{
            fatalError("Cannot create employee")
        }
        guard let employee2 = Employee(name: "Justin Norman", id: "3132BD4") else{
            fatalError("Cannot create employee")
        }
        guard let employee3 = Employee(name: "Jovon Craig", id: "546GD2Q") else{
            fatalError("Cannot create employee")
        }
        guard let employee4 = Employee(name: "Tim Bruce", id: "DA57643") else{
            fatalError("Cannot create employee")
        }
        guard let employee5 = Employee(name: "Tim Thomas", id: "GH433DS") else{
            fatalError("Cannot create employee")
        }
        guard let employee6 = Employee(name: "Patrick Pettegrow", id: "83HDI74") else{
            fatalError("Cannot create employee")
        }
        
        employees += [employee1, employee2, employee3, employee4, employee5, employee6]
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "goToHours", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
