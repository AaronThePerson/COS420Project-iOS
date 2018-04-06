//
//  HourEntryViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 4/2/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit

class HourEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectJobField: UITextField!
    @IBOutlet weak var hourEntrySelector: UISegmentedControl!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var allDay: UISwitch!
    @IBOutlet weak var allDayStackView: UIStackView!
    @IBOutlet weak var tipsField: UITextField!
    @IBOutlet weak var tipsSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var addShiftButton: UIButton!
    
    var employee = Employee(name: "test", id: "test", jobs: [Job(jobName: "test", commision: false)!])
    var selectedJob = Job(jobName: "test", commision: true)
    var shifts = [Shift]()
    let dateStartPicker = UIDatePicker()
    let dateEndPicker = UIDatePicker()
    var startFieldDate: Date?
    var endFieldDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createJobPicker()
        prepareUI()

        // Do any additional setup after loading the view.
    }
    
    func prepareUI(){
        tipsField.isHidden = true
        tipsField.keyboardType = .decimalPad
        tipsSwitch.isOn = false
        allDayStackView.isHidden = true
        allDay.isOn = false
        addShiftButton.layer.cornerRadius = 5
        hourEntrySelector.layer.cornerRadius = 5
    }
    
    func createJobPicker(){
        let jobPicker = UIPickerView()
        jobPicker.delegate = self
        selectJobField.inputView = jobPicker
    }
    
    func toggleSubmitButton(){
        if shifts.count >= 1{
            submitButton.isEnabled = true
        }
        else if shifts.count < 1{
            submitButton.isEnabled = false
        }
    }
    
    @IBAction func submitHours(_ sender: Any) {
        performSegue(withIdentifier: "goToReview", sender: Any?.self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (employee?.jobs?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return employee?.jobs![row].jobName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectJobField.text = employee?.jobs![row].jobName
        selectedJob = employee?.jobs![row]
        selectJobField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func addShiftButton(_ sender: Any) {
        let newshift = Shift(jobTitle: (selectedJob?.jobName)!)
        
        if hourEntrySelector.selectedSegmentIndex == 0{
//            newshift.startTime =
//            newshift.endTime =
            if tipsSwitch.isOn == true{
                //newshift.commission = tipsField.text
            }
        }
        else if hourEntrySelector.selectedSegmentIndex == 1{
            
        }
        
        
        shifts.append(newshift)
        tableView.reloadData()
        
        //clears last shifts data
        selectJobField.text = nil
        startTimeField.text = nil
        endTimeField.text = nil
        tipsField.text = nil
        tipsField.isHidden = true
    }

    @IBAction func selectChange(_ sender: UISegmentedControl) {
        switch hourEntrySelector.selectedSegmentIndex{
        case 0:
            startTimeField.placeholder = "Start Time"
            endTimeField.placeholder = "End Time"
            allDayStackView.isHidden = true
        case 1:
            startTimeField.placeholder = "Date"
            endTimeField.placeholder = "Hours"
            allDayStackView.isHidden = false
        default:
            break
        }
    }
    @IBAction func allDaySwitched(_ sender: Any) {
        if allDay.isOn == true{
            endTimeField.isHidden = true
        }
        else if allDay.isOn == false{
            endTimeField.isHidden = false
        }
    }
    
    @IBAction func switchChange(_ sender: Any) {
        if tipsSwitch.isOn == true{
            tipsField.isHidden = false
        }
        else if  tipsSwitch.isOn == false{
            tipsField.isHidden = true
            tipsField.text = nil
        }
    }
    
    @IBAction func startFieldEditing(_ sender: Any) {
        switch hourEntrySelector.selectedSegmentIndex {
        case 0:
            dateStartPicker.datePickerMode = .dateAndTime
            dateStartPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateStart(picker:)), for: UIControlEvents.valueChanged)
            startTimeField.inputView = dateStartPicker
        case 1:
            dateStartPicker.datePickerMode = .date
            dateStartPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateDuration(picker:)), for: UIControlEvents.valueChanged)
            startTimeField.inputView = dateStartPicker
        default:
            break
        }
    }
    
    @IBAction func endFieldEditing(_ sender: Any) {
        switch hourEntrySelector.selectedSegmentIndex {
        case 0:
            dateEndPicker.datePickerMode = .dateAndTime
            dateEndPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateEnd(picker:)), for: UIControlEvents.valueChanged)
            endTimeField.inputView = dateEndPicker
        case 1:
            dateEndPicker.datePickerMode = .countDownTimer
            dateEndPicker.addTarget(self, action: #selector(HourEntryViewController.collectHours(picker:)), for: UIControlEvents.valueChanged)
            endTimeField.inputView = dateEndPicker
        default:
            break
        }
    }
    
    @objc func collectDateStart(picker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        startTimeField.text = formatter.string(from: picker.date)
    }
    
    @objc func collectDateEnd(picker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        endTimeField.text = formatter.string(from: picker.date)
    }
    
    @objc func collectDateDuration(picker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        startTimeField.text = formatter.string(from: picker.date)
    }
    
    @objc func collectHours(picker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.none
        endTimeField.text = formatter.string(from: picker.date)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "hoursCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HourEntryTableViewCell else{
            fatalError("Cell could not be instantitated")
        }
        
        cell.jobLabel.text = shifts[indexPath.row].jobTitle
        
        switch hourEntrySelector.selectedSegmentIndex{
        case 0:
//            cell.startLabel.text =
//            cell.endLabel.text =
            if tipsField.hasText{
                cell.tipsLabel.isHidden = false
                cell.tipsLabel.text = self.tipsField.text
            }
            else{
                cell.tipsLabel.isHidden = true
            }
        case 1:
            cell.startLabel.text = self.startTimeField.text
            if allDay.isOn{
                cell.endLabel.text = "All Day"
            }
            else{
                cell.endLabel.text = self.endTimeField.text
            }
            if tipsField.hasText{
                cell.tipsLabel.isHidden = false
                cell.tipsLabel.text = self.tipsField.text
            }
            else{
                cell.tipsLabel.isHidden = true
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            shifts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        
    }
    
}
