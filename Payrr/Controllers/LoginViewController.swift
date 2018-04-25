//
//  LoginViewController.swift
//  Payrr
//
//  Created by Aaron Speakman on 3/5/18.
//  Copyright © 2018 Aaron Speakman. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let authURL: URL = URL(string: "https://umcos420gp.com/server/public/authenticate")!
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func attemptLogin(username: String, password: String, completion:@escaping (_ success: Bool) -> ()){
        //overwrite user input from text fields with test account
        let parameters = ["username": "SlartyBartfish", "password": "Swordfish"]
        
        //use user input from textfields
        //let parameters = ["username": username, "password": password]
        
        Alamofire.request(authURL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.response?.statusCode == 200{
                let dictionary = response.result.value as! [String: AnyObject]
                
                self.token = (dictionary["token"] as? String)!
                completion(true)
            }
            else if response.response?.statusCode == 401{
                completion(false)
            }
            
        }
        
    }
    
    func prepareUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        signInButton.layer.cornerRadius = 5
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 150), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEmployees"{
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! EmployeesTableViewController
            vc.token = token
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        attemptLogin(username: Email.text!, password: Password.text!, completion: { (success) in
            if success{
                self.performSegue(withIdentifier: "goToEmployees", sender: Any?.self)
            }
            else{
                let errorPopup = UIAlertController(title: "Login Failed", message: "Incorrect Username or Password", preferredStyle: UIAlertControllerStyle.alert)
                errorPopup.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(errorPopup, animated: true, completion: nil)
            }
        })
        
    }
    
}

