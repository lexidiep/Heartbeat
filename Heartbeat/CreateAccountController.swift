//
//  CreateAccountController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/13/20.
//

import UIKit

class CreateAccountController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var allView: UIView!
    
    // create username page
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameTitleLabel: UILabel!
    @IBOutlet weak var usernameCaptionLabel: UILabel!
    @IBOutlet weak var usernameCaption2Label: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameNextButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    // add email page
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailNextButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailErrorMessage: UILabel!
    
    
    // create password page
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var passwordNextButton: UIButton!
    
    
    // security page
    @IBOutlet weak var securityView: UIView!
    @IBOutlet weak var securityField: UITextField!
    @IBOutlet weak var securityNextButton: UIButton!
    @IBOutlet weak var questionPicker: UIPickerView!
    var pickerData:[String] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //  create username page
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        usernameField.delegate = self
        usernameField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        usernameNextButton.layer.cornerRadius = 5
        
        
        // add email page
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailField.delegate = self
        emailField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        emailNextButton.layer.cornerRadius = 5
        
        
        // create password page
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        passwordField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordNextButton.layer.cornerRadius = 5
        
        
        // security page
        questionPicker.delegate = self
        questionPicker.dataSource = self
        pickerData = [ "What is your mother's maiden name?", "What is the name of your first pet?", "What was your first car?", "What elementary school did you attend?", "What city were you born in?" ]
        securityField.attributedPlaceholder = NSAttributedString(string: "Answer", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        securityField.delegate = self
        securityField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        securityNextButton.layer.cornerRadius = 5
        
        //debugging
        /*
        if (UIApplication.shared.delegate as! AppDelegate).userData.count != 0 {
            print("\((UIApplication.shared.delegate as! AppDelegate).userData.count)) In CreateAccountScreen:")
            for i in 0...(UIApplication.shared.delegate as! AppDelegate).userData.count-1 {
                print((UIApplication.shared.delegate as! AppDelegate).userData[i]!.email!)
            }
        }
        else {
            print("(0) In CreateAccountScreen: empty")
        }
       */
        
        // username
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        allView.addGestureRecognizer(tap)
    }   // end viewDidLoad()
    
    @objc func dismissKeyboard() {
        allView.endEditing(true)
    }   // end dismissKeyboard()
 
    

    // button enabled on user input
    @objc func textFieldDidChange(_ textField : UITextField){
        var usernameTaken:Bool = false
        var emailUsed:Bool = false
        
        switch (textField) {
        case usernameField:
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                if (user?.username)?.lowercased() == (usernameField.text)?.lowercased() {
                    usernameTaken = true
                }
            }
            if usernameField.text != "" && !usernameTaken {
                usernameNextButton.alpha = 1.0
                usernameNextButton.isEnabled = true
                errorMessage.isHidden = true
                usernameField.layer.borderWidth = 0.0
                usernameTaken = false
                
            }
            else if usernameTaken {
                errorMessage.isHidden = false
                errorMessage.text = "That username is taken"
                usernameNextButton.alpha = 0.7
                usernameNextButton.isEnabled = false
                usernameField.layer.borderWidth = 1.0
                usernameField.layer.cornerRadius = 5.0
                usernameField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                usernameNextButton.alpha = 0.7
                usernameNextButton.isEnabled = false
            }
        
        case emailField:
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                if (user?.email)?.lowercased() == (emailField.text)?.lowercased() {
                    emailUsed = true
                }
            }
            if emailUsed {
                emailNextButton.alpha = 0.7
                emailNextButton.isEnabled = false
                emailErrorMessage.text = "That email address is already in use"
                emailErrorMessage.isHidden = false
                emailField.layer.borderWidth = 1.0
                emailField.layer.cornerRadius = 5.0
                emailField.layer.borderColor = UIColor.red.cgColor
            }
            else if emailField.text != "" && emailField.text!.contains("@") && (emailField.text!.suffix(4) == ".com" || emailField.text!.suffix(4) == ".net" || emailField.text!.suffix(4) == ".org" || emailField.text!.suffix(4) == ".edu" || emailField.text!.suffix(4) == ".gov" && !emailUsed) {
                emailNextButton.alpha = 1.0
                emailNextButton.isEnabled = true
                emailErrorMessage.isHidden = true
                emailField.layer.borderWidth = 0.0
                emailUsed = false
            }
            else {
                emailNextButton.alpha = 0.7
                emailNextButton.isEnabled = false
                emailErrorMessage.text = "Please enter a valid email address"
                emailErrorMessage.isHidden = false
                emailField.layer.borderWidth = 1.0
                emailField.layer.cornerRadius = 5.0
                emailField.layer.borderColor = UIColor.red.cgColor
            }
 
        case passwordField:
            if passwordField.text == confirmPasswordField.text && passwordField.text!.count >= 8 && confirmPasswordField.text!.count >= 8{
                passwordNextButton.alpha = 1.0
                passwordNextButton.isEnabled = true
                passwordErrorMessage.isHidden = true
                confirmPasswordField.layer.borderWidth = 0.0
            }
            else if passwordField.text!.count < 8 {
                passwordNextButton.alpha = 0.7
                passwordNextButton.isEnabled = false
                passwordErrorMessage.isHidden = false
                passwordErrorMessage.text = "Password is too weak."
                passwordField.layer.borderWidth = 1.0
                passwordField.layer.cornerRadius = 5.0
                passwordField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                passwordErrorMessage.isHidden = true
                passwordField.layer.borderWidth = 0.0
            }
        
        case confirmPasswordField:
            if passwordField.text == confirmPasswordField.text && passwordField.text!.count >= 8 && confirmPasswordField.text!.count >= 8{
                passwordNextButton.alpha = 1.0
                passwordNextButton.isEnabled = true
                passwordErrorMessage.isHidden = true
                confirmPasswordField.layer.borderWidth = 0.0
            }
            else if passwordField.text != confirmPasswordField.text {
                passwordNextButton.alpha = 0.7
                passwordNextButton.isEnabled = false
                passwordErrorMessage.isHidden = false
                passwordErrorMessage.text = "Passwords do not match"
                confirmPasswordField.layer.borderWidth = 1.0
                confirmPasswordField.layer.cornerRadius = 5.0
                confirmPasswordField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                passwordNextButton.alpha = 0.7
                passwordNextButton.isEnabled = false
            }
        
        case securityField:
            if securityField.text != "" {
                securityNextButton.alpha = 1.0
                securityNextButton.isEnabled = true
            }
            else {
                securityNextButton.alpha = 0.7
                securityNextButton.isEnabled = false
            }
        
        default: fatalError("Unknown field: \(textField)")
            
        } // end textField switch
        
    }   // end textFieldDidChange()
    
    
    // show add email page
    // check through users array for existing username
    @IBAction func usernameNext(_ sender: Any) {
        self.viewSlideInFromRight(view: emailView)
        usernameView.isHidden = true
    }   // end usernameNext
    
    
    // show create password page
    // check through users array for existing email
    @IBAction func emailNext(_ sender: Any) {
        self.viewSlideInFromRight(view: passwordView)
        emailView.isHidden = true
    }   // end emailnext
    
    // go back to username page
    @IBAction func emailBack(_ sender: Any) {
        self.viewSlideInFromLeft(view: usernameView)
        emailView.isHidden = true
    }   // end emailBack
    
    
    // show create security page
    @IBAction func passwordNext(_ sender: Any) {
        self.viewSlideInFromRight(view: securityView)
        passwordView.isHidden = true
    }   // end passwordNext
    
    // go back to email page
    @IBAction func passwordBack(_ sender: Any) {
        self.viewSlideInFromLeft(view: emailView)
        passwordView.isHidden = true
    }   // end passwordBack
    
    
    // go back to login screen and add all info to users array
    @IBAction func securityNext(_ sender: Any) {
        
        // warning: this is just a test -- user's saved songs needs to be assigned to savedSongs in parameter
        let createTempUser:userInfo = userInfo(username: usernameField.text, email: emailField.text, password: passwordField.text, savedSongs: [], securityQuestion: pickerData[questionPicker.selectedRow(inComponent: 0)], securityAnswer: securityField.text)
        
        (UIApplication.shared.delegate as! AppDelegate).userData.append(createTempUser)
        
        backToLoginView()
    }   // end securityNext
    
    
    // go back to password page
    @IBAction func securityBack(_ sender: Any) {
        self.viewSlideInFromLeft(view: passwordView)
        securityView.isHidden = true
    }   // end securityBack
    
    
    // cancel create account and go back to login screen
    @IBAction func cancelCreateAccount(_ sender: Any) {
        backToLoginView()
    }   // end cancelCreateAccount
    
    
    // function to go back to login screen (for cancel button and complete button)
    func backToLoginView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginController
        loginViewController.modalPresentationStyle = .fullScreen
        self.viewSlideInFromTop(controller: loginViewController)
    }
    
    
    // slide from top animation for cancel create account
    func viewSlideInFromTop(controller: UIViewController) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        present(controller, animated: false, completion: nil)
    }   // end viewSlideInFromTop()
    
    
    // slide animation for next button
    func viewSlideInFromRight(view: UIView) -> Void {
        view.isHidden = false
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideInFromRight()
    
    // slide animation for back button
    func viewSlideInFromLeft(view: UIView) -> Void {
        view.isHidden = false
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideInFromLeft()
    
    
    // data source/delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }   // numberOfComponents (pickerView -> security page)
       
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }   // numberOfRowsInComponents (pickerView -> security page)
        
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }   // titleForRow (pickerView -> security page)
    
    
    // Capture the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }   // didSelectRow (pickerView -> security page)


}   // end CreateAccountController
