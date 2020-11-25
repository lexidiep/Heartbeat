//
//  LoginController.swift
//  Heartbeat
//
//  Created by Heartbeat on 10/11/20.
//

import UIKit

class LoginController: UIViewController {

    // UIelements
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAcctButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create test user account
        let testAccount = userInfo(username: "test", email: "test@test.com", password: "testtest", savedSongs: [], securityQuestion: "What is your mother's maiden name?", securityAnswer: "test")
        (UIApplication.shared.delegate as! AppDelegate).userData.append(testAccount)
        
        
        loginButton.layer.cornerRadius = 5
        createAcctButton.layer.cornerRadius = 5
        
        // username field
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username or email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // password field
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        // debugging
        /*
        if ((UIApplication.shared.delegate as! AppDelegate).userData.count != 0) {
            print("(\((UIApplication.shared.delegate as! AppDelegate).userData.count)) In LoginScreen: ")
            for i in 0...(UIApplication.shared.delegate as! AppDelegate).userData.count-1 {
                print((UIApplication.shared.delegate as! AppDelegate).userData[i]!.username!)
            }
        }
        else {
            print("(0) In LoginScreen: empty")
        }
    */
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        loginView.addGestureRecognizer(tap)
 
    }   // end viewDidLoad()
    
    
    @IBAction func loginTapped(_ sender: Any) {
        var userExists:Bool = false
        var passwordCorrect:Bool = false
        
        for user in (UIApplication.shared.delegate as! AppDelegate).userData {
            if (user?.username)?.lowercased() == (usernameField.text)?.lowercased() || (user?.email)?.lowercased() == (usernameField.text?.lowercased()) {
                userExists = true

                if user?.password == passwordField.text {
                    passwordCorrect = true
                }
            }
        }

        if userExists && passwordCorrect {
            errorMessage.isHidden = true
            passwordField.layer.borderWidth = 0.0
            usernameField.layer.borderWidth = 0.0
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
        else if usernameField.text == "" {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter your username or email"
            usernameField.layer.borderWidth = 1.0
            usernameField.layer.cornerRadius = 5.0
            usernameField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 0.0
        }
        else if !userExists {
            errorMessage.isHidden = false
            errorMessage.text = "User does not exist"
            usernameField.layer.borderWidth = 1.0
            usernameField.layer.cornerRadius = 5.0
            usernameField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 0.0
        }
        else if passwordField.text == "" {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter your password"
            passwordField.layer.borderWidth = 1.0
            passwordField.layer.cornerRadius = 5.0
            passwordField.layer.borderColor = UIColor.red.cgColor
            usernameField.layer.borderWidth = 0.0
        }
        else if userExists && !passwordCorrect {
            errorMessage.isHidden = false
            errorMessage.text = "Password is incorrect"
            passwordField.layer.borderWidth = 1.0
            passwordField.layer.cornerRadius = 5.0
            passwordField.layer.borderColor = UIColor.red.cgColor
            usernameField.layer.borderWidth = 0.0
        }
        
    }   // end loginTapped
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        loginView.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var name:String = ""
        
        for user in (UIApplication.shared.delegate as! AppDelegate).userData {
            if (user?.username)?.lowercased() == (usernameField.text)?.lowercased() || (user?.email)?.lowercased() == (usernameField.text?.lowercased()) {
                name = user!.username!
            }
        }
        
        if segue.identifier == "loginToHome" {
            let destination = segue.destination as! HomeController
            destination.users_name = name
        }
    }
    
    
}   // end LoginController

