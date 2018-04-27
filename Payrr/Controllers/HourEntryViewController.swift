//
//  HourEntryViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 4/2/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit
import TRCurrencyTextField

class HourEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectJobField: UITextField!
    @IBOutlet weak var hourEntrySelector: UISegmentedControl!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var allDay: UISwitch!
    @IBOutlet weak var allDayStackView: UIStackView!
    @IBOutlet weak var tipsSwitch: UISwitch!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var addShiftButton: UIButton!
    @IBOutlet weak var tipsField: TRCurrencyTextField!
    
    var employee: Employee?
    var selectedJob: Job?
    var shifts = [Shift]()
    let dateStartPicker = UIDatePicker()
    let dateEndPicker = UIDatePicker()
    let jobPicker = UIPickerView()
    var startFieldDate: Date?
    var endFieldDate: Date?
    var enteredStartDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createJobPicker()
        prepareUI()
        prepareDatePickers()
    }
    
    func prepareUI(){
        tipsField.isHidden = true
        tipsField.keyboardType = .decimalPad
        tipsField.currencyCode = "USD"
        tipsField.setLocale(Locale(identifier: "en_US"))
        tipsSwitch.isOn = false
        allDayStackView.isHidden = true
        allDay.isOn = false
        addShiftButton.layer.cornerRadius = 5
        hourEntrySelector.layer.cornerRadius = 5
        tableView.estimatedRowHeight = 100
    }
    
    func prepareDatePickers(){
        let toolbar1 = UIToolbar()
        toolbar1.barStyle = UIBarStyle.default
        toolbar1.isTranslucent = true
        toolbar1.sizeToFit()
        
        let toolbar2 = UIToolbar()
        toolbar2.barStyle = UIBarStyle.default
        toolbar2.isTranslucent = true
        toolbar2.sizeToFit()
        
        let doneStartButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(HourEntryViewController.dismissStartPicker))
        let doneEndButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(HourEntryViewController.dismissEndPicker))
        
        toolbar1.setItems([doneStartButton], animated: false)
        toolbar2.setItems([doneEndButton], animated: false)
        
        dateStartPicker.datePickerMode = .dateAndTime
        dateStartPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateStart(picker:)), for: UIControlEvents.valueChanged)
        dateStartPicker.maximumDate = Date()
        startTimeField.inputView = dateStartPicker
        startTimeField.inputAccessoryView = toolbar1
        
        
        dateEndPicker.datePickerMode = .dateAndTime
        dateEndPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateEnd(picker:)), for: UIControlEvents.valueChanged)
        dateEndPicker.maximumDate = Date()
        endTimeField.inputView = dateEndPicker
        endTimeField.inputAccessoryView = toolbar2
    }
    
    func createJobPicker(){
        jobPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(HourEntryViewController.dismissJobPicker))
        
        toolbar.setItems([doneButton], animated: false)
        
        selectJobField.inputView = jobPicker
        selectJobField.inputAccessoryView = toolbar
    }
    
    func toggleSubmitButton(){
        if shifts.count >= 1{
            submitButton.isEnabled = true
        }
        else if shifts.count < 1{
            submitButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReview"{
            let sendPayrollController = segue.destination as! SendPayrollViewController
            sendPayrollController.shiftsToAdd = shifts
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
    
    @objc func dismissJobPicker(){
        selectedJob = employee?.jobs![jobPicker.selectedRow(inComponent: 0)]
        selectJobField.text = selectedJob?.jobName
        selectJobField.resignFirstResponder()
    }
    
    @objc func dismissStartPicker(){
        if hourEntrySelector.selectedSegmentIndex == 0{
            collectDateStart(picker: dateStartPicker)
        }
        else{
            collectDateDuration(picker: dateStartPicker)
        }
        startTimeField.resignFirstResponder()
    }
    
    @objc func dismissEndPicker(){
        if hourEntrySelector.selectedSegmentIndex == 0{
            collectDateEnd(picker: dateEndPicker)
        }
        else{
            collectHours(picker: dateEndPicker)
        }
        endTimeField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func addShiftButton(_ sender: Any) {
        
        var entryType: Bool = true
        if hourEntrySelector.selectedSegmentIndex == 1{
            entryType = false
        }
        
        let newshift = Shift(job: selectedJob!, entryType: entryType)
        
        if entryType{
            newshift.startTime = dateStartPicker.date
            newshift.endTime = dateEndPicker.date
            
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
            formatter.timeStyle = DateFormatter.Style.short
            
            newshift.startTimeText = formatter.string(from: newshift.startTime!)
            newshift.endTimeText = formatter.string(from: newshift.endTime!)
            
        }
        else{
            newshift.date = dateStartPicker.date
            newshift.duration = dateEndPicker.date
            
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
            
            let calendar = Calendar.current
            
            let hours = calendar.component(.hour, from: newshift.duration!)
            let minutes = calendar.component(.minute, from: newshift.duration!)
            
            newshift.dateText = formatter.string(from: newshift.date!)
            if allDay.isOn == true{
                newshift.durationText = "All Day"
            }
            else{
                var output: String = ""
                
                if hours == 1{
                    output = output + String(hours) + " hour "
                }
                else if hours > 1{
                    output = output + String(hours) + " hours "
                }
                
                if minutes == 1{
                    output = output + String(minutes) + " minute"
                }
                else if minutes > 1{
                    output = output + String(minutes) + " minutes"
                }
                
                newshift.durationText = output
            }
        }
        
        if tipsSwitch.isOn == true{
            newshift.commission = tipsField.text!
        }
        else{
            newshift.commission = nil
        }
        
        if errorCheck() == true{
            shifts.append(newshift)
            tableView.reloadData()
            toggleSubmitButton()
            dismissKeyboard()
            
            //clears last shifts data
            selectJobField.text = nil
            startTimeField.text = nil
            endTimeField.text = nil
            tipsField.text = nil
            tipsSwitch.isOn = false
            tipsField.isHidden = true
            dateStartPicker.minimumDate = nil
            dateEndPicker.minimumDate = nil
            dateStartPicker.maximumDate = Date()
            dateEndPicker.maximumDate = Date()
        }
    }

    @IBAction func selectChange(_ sender: UISegmentedControl) {
        switch hourEntrySelector.selectedSegmentIndex{
        case 0:
            endTimeField.isHidden = false
            startTimeField.placeholder = "Start Time"
            startTimeField.text = ""
            endTimeField.placeholder = "End Time"
            endTimeField.text = ""
            allDayStackView.isHidden = true
            dateStartPicker.datePickerMode = .dateAndTime
            dateStartPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateStart(picker:)), for: UIControlEvents.valueChanged)
            startTimeField.inputView = dateStartPicker
            dateEndPicker.datePickerMode = .dateAndTime
            dateEndPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateEnd(picker:)), for: UIControlEvents.valueChanged)
            endTimeField.inputView = dateEndPicker
        case 1:
            if allDay.isOn == true{
                endTimeField.isHidden = true
            }
            startTimeField.placeholder = "Date"
            startTimeField.text = ""
            endTimeField.placeholder = "Hours"
            endTimeField.text = ""
            allDayStackView.isHidden = false
            dateStartPicker.datePickerMode = .date
            dateStartPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateDuration(picker:)), for: UIControlEvents.valueChanged)
            startTimeField.inputView = dateStartPicker
            dateEndPicker.datePickerMode = .countDownTimer
            dateEndPicker.addTarget(self, action: #selector(HourEntryViewController.collectHours(picker:)), for: UIControlEvents.valueChanged)
            endTimeField.inputView = dateEndPicker
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
        dateEndPicker.datePickerMode = .dateAndTime
        dateEndPicker.addTarget(self, action: #selector(HourEntryViewController.collectDateEnd(picker:)), for: UIControlEvents.valueChanged)
        endTimeField.inputView = dateEndPicker
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
            //collectDateDuration(picker: dateStartPicker)
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
    
    @IBAction func startFieldEnding(_ sender: Any) {
        if hourEntrySelector.selectedSegmentIndex == 0{
            dateEndPicker.minimumDate = dateStartPicker.date
        }
    }
    
    @IBAction func endFieldEnding(_ sender: Any) {
        if hourEntrySelector.selectedSegmentIndex == 0{
            dateStartPicker.maximumDate = dateEndPicker.date
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
        let date = picker.date
        let calendar = Calendar.current
        
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        var output: String = ""
        
        if hours == 1{
            output = output + String(hours) + " hour "
        }
        else if hours > 1{
            output = output + String(hours) + " hours "
        }
        
        if minutes == 1{
            output = output + String(minutes) + " minute"
        }
        else if minutes > 1{
            output = output + String(minutes) + " minutes"
        }
        
        endTimeField.text = output
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "hoursCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HourEntryTableViewCell else{
            fatalError("Cell could not be instantitated")
        }
        
        cell.jobLabel.text = shifts[indexPath.row].job.jobName
        
        if shifts[indexPath.row].entryType == true{
            cell.startLabel.text = "Start: " + shifts[indexPath.row].startTimeText!
            cell.endLabel.text = "End: " + shifts[indexPath.row].endTimeText!
            if shifts[indexPath.row].commission != nil{
                cell.tipsLabel.isHidden = false
                cell.tipsLabel.text = "Tips/Commision: " + shifts[indexPath.row].commission!
            }
            else{
                cell.tipsLabel.isHidden = true
            }
        }
        else{
            cell.startLabel.text = "Date: " + shifts[indexPath.row].dateText!
            cell.endLabel.text = "Duration: " + shifts[indexPath.row].durationText!
            if shifts[indexPath.row].commission != nil{
                cell.tipsLabel.isHidden = false
                cell.tipsLabel.text = "Tips/Commision: " + shifts[indexPath.row].commission!
            }
            else{
                cell.tipsLabel.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit") { (action, indexpath) in
            let editableShift = self.shifts.remove(at: indexPath.row)
            if editableShift.entryType == true{
                self.startTimeField.text = editableShift.startTimeText
                self.dateStartPicker.date = editableShift.startTime!
                self.endTimeField.text = editableShift.endTimeText
                self.dateEndPicker.date = editableShift.endTime!
                if editableShift.commission != nil {
                    self.tipsField.text = editableShift.commission
                    self.tipsSwitch.isOn = true
                    self.tipsField.isHidden = false
                }
                let jobNum = self.employee?.jobs!.index(of: editableShift.job)
                self.jobPicker.selectRow(jobNum!, inComponent: 0, animated: false)
                self.selectJobField.text = editableShift.job.jobName
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                self.toggleSubmitButton()
            }
            else{
                self.startTimeField.text = editableShift.dateText
                self.dateStartPicker.date = editableShift.date!
                if editableShift.durationText == "All Day"{
                    self.allDay.isOn = true
                    self.endTimeField.isHidden = true
                }
                else{
                    self.allDay.isOn = false
                    self.endTimeField.isHidden = false
                    self.endTimeField.text = editableShift.durationText
                    self.dateEndPicker.date = editableShift.date!
                }
                if editableShift.commission != nil {
                    self.tipsField.text = editableShift.commission
                    self.tipsSwitch.isOn = true
                    self.tipsField.isHidden = false
                }
            }
            
        }
        editRowAction.backgroundColor = UIColor.orange
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete") { (action, indexpath) in
            self.shifts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            self.toggleSubmitButton()
        }
        deleteRowAction.backgroundColor = UIColor.red
        
        return [deleteRowAction,editRowAction]
        
    }
    
    func errorCheck()->Bool{
        var noError = true
        
        if selectJobField.hasText != true {
            noError = false
            errorAlert(alertText: "Select a job.")
        }
        else if startTimeField.hasText != true{
            noError = false
            switch hourEntrySelector.selectedSegmentIndex{
            case 0:
                errorAlert(alertText: "Select a start time.")
            case 1:
                errorAlert(alertText: "Select a date.")
            default:
                break
            }
        }
        else if endTimeField.hasText != true && allDay.isOn == false{
            noError = false
            switch hourEntrySelector.selectedSegmentIndex{
            case 0:
                errorAlert(alertText: "Select an end time.")
            case 1:
                errorAlert(alertText: "Enter hours worked.")
            default:
                break
            }
        }
        else if startTimeField.text == endTimeField.text{
            noError = false
            errorAlert(alertText: "Start and end times are the same.")
        }
        
        return noError
    }
    
    
    func errorAlert(alertText: String){
        let errorPopup = UIAlertController(title: "Shift Error", message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        errorPopup.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(errorPopup, animated: true, completion: nil)
    }
    
}
