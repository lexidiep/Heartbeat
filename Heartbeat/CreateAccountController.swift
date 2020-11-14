//
//  CreateAccountController.swift
//  Heartbeat
//
//  Created by Lexi Diep on 11/13/20.
//

import UIKit

class CreateAccountController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // variables
    // struct for saved songs by user
    struct saved {
        var title:String?
        var artist: String?
        var id:String?
    }
    // struct for individual user data
    struct userInfo {
        var username:String?
        var email:String?
        var password:String?
        var savedSongs:[saved?]
        var securityQuestion:String?
        var securityAnswer: String?
    }
    var users = [userInfo?]()   // array of structs used to store user information
    
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
        
        
        // add email page
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailField.delegate = self
        emailField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
        // create password page
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        passwordField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
        // security page
        questionPicker.delegate = self
        questionPicker.dataSource = self
        pickerData = [ "What is your mother's maiden name?", "What is the name of your first pet?", "What was your first car?", "What elementary school did you attend?", "What city were you born in?" ]
        securityField.attributedPlaceholder = NSAttributedString(string: "Answer", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        securityField.delegate = self
        securityField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }   // end viewDidLoad()
    

    // button enabled on user input
    @objc func textFieldDidChange(_ textField : UITextField){
        if textField == usernameField {
            if usernameField.text != "" {
                usernameNextButton.alpha = 1.0
                usernameNextButton.isEnabled = true
            }
            else {
                usernameNextButton.alpha = 0.7
                usernameNextButton.isEnabled = false
            }
        }
        else if textField == emailField {
            if emailField.text != "" && emailField.text!.contains("@") && (emailField.text!.suffix(4) == ".com" || emailField.text!.suffix(4) == ".net" || emailField.text!.suffix(4) == ".org" || emailField.text!.suffix(4) == ".edu" || emailField.text!.suffix(4) == ".gov") {
                emailNextButton.alpha = 1.0
                emailNextButton.isEnabled = true
                emailErrorMessage.isHidden = true
                emailField.layer.borderWidth = 0.0
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
        }
        else if textField == passwordField {
            if passwordField.text!.count < 8 {
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
        }
        else if textField == confirmPasswordField {
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
        }
        else if textField == securityField {
            if securityField.text != "" {
                securityNextButton.alpha = 1.0
                securityNextButton.isEnabled = true
            }
            else {
                securityNextButton.alpha = 0.7
                securityNextButton.isEnabled = false
            }
        }
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
    
    
    // securitynext should go to login screen and add all info to array
    
    // go back to password page
    @IBAction func securityBack(_ sender: Any) {
        self.viewSlideInFromLeft(view: passwordView)
        securityView.isHidden = true
    }   // end securityBack
    
    
    // cancel create account and go back to login screen
    @IBAction func cancelCreateAccount(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginController
        loginViewController.modalPresentationStyle = .fullScreen
        self.viewSlideInFromTop(controller: loginViewController)
        
    }   // end cancelCreateAccount
    
    
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
        //
    }   // didSelectRow (pickerView -> security page)

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
