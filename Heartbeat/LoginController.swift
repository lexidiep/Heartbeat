//
//  LoginController.swift
//  Heartbeat
//
//  Created by Heartbeat on 10/11/20.
//

import UIKit

var loginViewCount:Int = 1  // for storing admin account on first visit to login screen

class LoginController: UIViewController, UITextFieldDelegate {

    // UIelements
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAcctButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var orLeftLine: UILabel!
    @IBOutlet weak var orRightLine: UILabel!
    @IBOutlet weak var or: UILabel!
    
    // Forgot Password View
    @IBOutlet weak var usernameEmailView: UIView!
    @IBOutlet weak var usernameNextButton: UIButton!
    var usernameNextDisabled:Bool = true
    @IBOutlet weak var usernameEmailField: UITextField!
    @IBOutlet weak var forgotPasswordError: UILabel!
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var securityQuestionView: UIView!
    @IBOutlet weak var securityNextButton: UIButton!
    @IBOutlet weak var securityAnswerField: UITextField!
    @IBOutlet weak var securityQuestionLabel: UILabel!
    var forgetfulUser:String = ""   // stores username OR email of user that forgot password
    var forgetfulUsername:String = ""   //stores the username of the user that forgot password
    var securityNextDisabled:Bool = true
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var createPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var resetPasswordErrorLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    var currentPassword:String = "" // stores the current password of user that forgot password
    var newPassword:String = "" // stores the new password of the user that forgot password
    var resetPasswordDisabled:Bool = true
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create test user account on first visit to login screen
        if loginViewCount == 1 {
            let testAccount = userInfo()
            testAccount.username = "admin"
            testAccount.email = "test@test.com"
            testAccount.password = "testtest"
            testAccount.savedSongs = []
            testAccount.securityQuestion = "What is your mother's maiden name?"
            testAccount.securityAnswer = "test"
            testAccount.name = "ASU"
            testAccount.profilePic = UIImage(named: "sparky")
            (UIApplication.shared.delegate as! AppDelegate).userData.append(testAccount)
        }
        
        
        loginButton.layer.cornerRadius = 5
        createAcctButton.layer.cornerRadius = 5
        
        // username field
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username or email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // password field
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        // FOR FORGOT PASSWORD
                
        // forgot password next buttons
        usernameNextButton.layer.cornerRadius = 5
        usernameNextButton.alpha = 0.7
        securityNextButton.layer.cornerRadius = 5
        securityNextButton.alpha = 0.7
        resetPasswordButton.layer.cornerRadius = 5
        resetPasswordButton.alpha = 0.7
        
        // forgot password process views
        forgotPasswordView.layer.cornerRadius = 5
        usernameEmailView.layer.cornerRadius = 5
        securityQuestionView.layer.cornerRadius = 5
        resetPasswordView.layer.cornerRadius = 5
        
        // text field delegates/targets
        usernameEmailField.delegate = self
        usernameEmailField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        usernameEmailField.attributedPlaceholder = NSAttributedString(string: "Username or Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        securityAnswerField.delegate = self
        securityAnswerField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        securityAnswerField.attributedPlaceholder = NSAttributedString(string: "Answer to Security Question", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        createPasswordField
            .delegate = self
        createPasswordField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        createPasswordField.attributedPlaceholder = NSAttributedString(string: "Create a New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        confirmPasswordField.delegate = self
        confirmPasswordField.addTarget(self, action: #selector(CreateAccountController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
      
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        loginView.addGestureRecognizer(tap)
        loginButton.addGestureRecognizer(tap)
        
 
    }   // end viewDidLoad()
    
    
    
    
    
    // ---------------- USER LOG IN CREDENTIALS ------------------
    
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

        // if the user exists and the password is correct for the user
        if userExists && passwordCorrect {
            errorMessage.isHidden = true
            passwordField.layer.borderWidth = 0.0
            usernameField.layer.borderWidth = 0.0
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
        // if the username field is empty
        else if usernameField.text == "" {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter your username or email"
            usernameField.layer.borderWidth = 1.0
            usernameField.layer.cornerRadius = 5.0
            usernameField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 0.0
        }
        // if the username does not exist
        else if !userExists {
            errorMessage.isHidden = false
            errorMessage.text = "User does not exist"
            usernameField.layer.borderWidth = 1.0
            usernameField.layer.cornerRadius = 5.0
            usernameField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 0.0
        }
        // if the password field is empty
        else if passwordField.text == "" {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter your password"
            passwordField.layer.borderWidth = 1.0
            passwordField.layer.cornerRadius = 5.0
            passwordField.layer.borderColor = UIColor.red.cgColor
            usernameField.layer.borderWidth = 0.0
        }
        // if the user exists, but the password is incorrect
        else if userExists && !passwordCorrect {
            errorMessage.isHidden = false
            errorMessage.text = "Password is incorrect"
            passwordField.layer.borderWidth = 1.0
            passwordField.layer.cornerRadius = 5.0
            passwordField.layer.borderColor = UIColor.red.cgColor
            usernameField.layer.borderWidth = 0.0
        }
        
    }   // end loginTapped
    
    
    
    
    
    // ----------------- FORGOT PASSWORD ------------------
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        
        forgotPasswordView.isHidden = false
        self.viewSlideInFromTop(view: forgotPasswordView)
        
        logo.alpha = 0.3
        orLeftLine.alpha = 0.3
        or.alpha = 0.3
        orRightLine.alpha = 0.3
        createAcctButton.alpha = 0.3
        createAcctButton.isEnabled = false
        
    } // end forgotPasswordTapped
    
    
    // button enabled on user input
    @objc func textFieldDidChange(_ textField : UITextField){
        var userExists:Bool = false
        
        switch textField {
        // field for username/email
        case usernameEmailField:
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                
                if (user?.username)?.lowercased() == (usernameEmailField.text)?.lowercased()  || (user?.email)?.lowercased() == (usernameEmailField.text)?.lowercased() {
                    userExists = true
                    forgetfulUser = usernameEmailField.text!
                    currentPassword = user!.password!
                    forgetfulUsername = user!.username!
                }
                
            }
            
            // if the user exists, hide error and enable next button
            if (userExists) {
                usernameNextDisabled = false
                usernameNextButton.alpha = 1.0
                usernameNextButton.isEnabled = true
                forgotPasswordError.isHidden = true
                usernameEmailField.layer.borderWidth = 0.0
            }
            // if user does not exist show error, next button is disabled
            else if (!userExists && usernameEmailField.text != ""){
                usernameNextDisabled = true
                forgotPasswordError.isHidden = false
                forgotPasswordError.text = "This user does not exist"
                usernameNextButton.alpha = 0.7
                usernameNextButton.isEnabled = false
                usernameEmailField.layer.borderWidth = 1.0
                usernameEmailField.layer.cornerRadius = 5.0
                usernameEmailField.layer.borderColor = UIColor.red.cgColor
            }
            
        // field for answer to security question
        case securityAnswerField:
            //print(forgetfulUser)
            
            var isCorrectAnswer:Bool = false
            
            // check for each user to get user's security answer
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                
                // if answer to security question for this user is correct
                if ((user?.username)?.lowercased() == forgetfulUser.lowercased() || (user?.email)?.lowercased() == forgetfulUser.lowercased()) && (user?.securityAnswer)?.lowercased() == securityAnswerField.text?.lowercased() {
                    isCorrectAnswer = true
                }
                // if answer to security question for this user is incorrect
                else if ((user?.username)?.lowercased() == forgetfulUser.lowercased() || (user?.email)?.lowercased() == forgetfulUser.lowercased()) && (user?.securityAnswer)?.lowercased() != securityAnswerField.text?.lowercased() {
                    isCorrectAnswer = false
                }
            }
            if isCorrectAnswer {
                securityNextDisabled = false
                securityNextButton.alpha = 1.0
                securityNextButton.isEnabled = true
                securityAnswerField.layer.borderWidth = 0.0
            }
            else if !isCorrectAnswer && securityAnswerField.text != "" {
                securityNextDisabled = true
                securityNextButton.alpha = 0.7
                securityNextButton.isEnabled = false
                securityAnswerField.layer.borderWidth = 1.5
                securityAnswerField.layer.cornerRadius = 5.0
                securityAnswerField.layer.borderColor = UIColor.red.cgColor
            }
            
        // field for creating new password
        case createPasswordField:
            if createPasswordField.text == confirmPasswordField.text && createPasswordField.text!.count >= 8 && confirmPasswordField.text!.count >= 8 && createPasswordField.text != currentPassword {
                resetPasswordButton.alpha = 1.0
                resetPasswordButton.isEnabled = true
                resetPasswordErrorLabel.isHidden = true
                confirmPasswordField.layer.borderWidth = 0.0
                createPasswordField.layer.borderWidth = 0.0
                resetPasswordDisabled = false
                newPassword = createPasswordField.text!
            }
            // if the password is too short
            else if createPasswordField.text!.count < 8 {
                resetPasswordButton.alpha = 0.7
                resetPasswordButton.isEnabled = false
                resetPasswordErrorLabel.isHidden = false
                resetPasswordErrorLabel.text = "Password is too weak."
                resetPasswordErrorLabel.font = resetPasswordErrorLabel.font.withSize(18)
                createPasswordField.layer.borderWidth = 1.0
                createPasswordField.layer.cornerRadius = 5.0
                createPasswordField.layer.borderColor = UIColor.red.cgColor
                resetPasswordDisabled = true
            }
            else if createPasswordField.text!.count >= 8 && createPasswordField.text == currentPassword {
                resetPasswordButton.alpha = 0.7
                resetPasswordButton.isEnabled = false
                resetPasswordErrorLabel.isHidden = false
                resetPasswordErrorLabel.font = resetPasswordErrorLabel.font.withSize(15)
                resetPasswordErrorLabel.text = "Choose a password that is not your current password"
                createPasswordField.layer.borderWidth = 1.0
                createPasswordField.layer.cornerRadius = 5.0
                createPasswordField.layer.borderColor = UIColor.red.cgColor
                resetPasswordDisabled = true
            }
            else if createPasswordField.text != confirmPasswordField.text  && confirmPasswordField.text != "" {
                resetPasswordButton.alpha = 0.7
                resetPasswordButton.isEnabled = false
                resetPasswordErrorLabel.isHidden = false
                resetPasswordErrorLabel.font = resetPasswordErrorLabel.font.withSize(18)
                resetPasswordErrorLabel.text = "Passwords do not match"
                confirmPasswordField.layer.borderWidth = 1.0
                confirmPasswordField.layer.cornerRadius = 5.0
                confirmPasswordField.layer.borderColor = UIColor.red.cgColor
                createPasswordField.layer.borderWidth = 1.0
                createPasswordField.layer.cornerRadius = 5.0
                createPasswordField.layer.borderColor = UIColor.red.cgColor
                resetPasswordDisabled = true
            }
            else {
                resetPasswordErrorLabel.isHidden = true
                createPasswordField.layer.borderWidth = 0.0
                confirmPasswordField.layer.borderWidth = 0.0
                confirmPasswordField.layer.cornerRadius = 5.0
                createPasswordField.layer.cornerRadius = 5.0
            }
            
        // field for confirming new password
        case confirmPasswordField:
            if createPasswordField.text == confirmPasswordField.text && createPasswordField.text!.count >= 8 && confirmPasswordField.text!.count >= 8 && createPasswordField.text != currentPassword {
                resetPasswordButton.alpha = 1.0
                resetPasswordButton.isEnabled = true
                resetPasswordErrorLabel.isHidden = true
                confirmPasswordField.layer.borderWidth = 0.0
                createPasswordField.layer.borderWidth = 0.0
                resetPasswordDisabled = false
                newPassword = createPasswordField.text!
            }
            else if createPasswordField.text!.count >= 8 && createPasswordField.text == currentPassword {
                resetPasswordButton.alpha = 0.7
                resetPasswordButton.isEnabled = false
                resetPasswordErrorLabel.isHidden = false
                resetPasswordErrorLabel.font = resetPasswordErrorLabel.font.withSize(15)
                resetPasswordErrorLabel.text = "Choose a password that is not your current password"
                createPasswordField.layer.borderWidth = 1.0
                createPasswordField.layer.cornerRadius = 5.0
                createPasswordField.layer.borderColor = UIColor.red.cgColor
                resetPasswordDisabled = true
            }
            else if createPasswordField.text != confirmPasswordField.text {
                resetPasswordButton.alpha = 0.7
                resetPasswordButton.isEnabled = false
                resetPasswordErrorLabel.isHidden = false
                resetPasswordErrorLabel.font = resetPasswordErrorLabel.font.withSize(18)
                resetPasswordErrorLabel.text = "Passwords do not match"
                confirmPasswordField.layer.borderWidth = 1.0
                confirmPasswordField.layer.cornerRadius = 5.0
                confirmPasswordField.layer.borderColor = UIColor.red.cgColor
                createPasswordField.layer.borderWidth = 1.0
                createPasswordField.layer.cornerRadius = 5.0
                createPasswordField.layer.borderColor = UIColor.red.cgColor
                resetPasswordDisabled = true
            }
            else {
                resetPasswordButton.alpha = 0.7
                resetPasswordButton.isEnabled = false
            }
            
        default: fatalError("Unknown field: \(textField)")
            
        } // end switch case for text field
        
    } // end text field did change
    
    
    // slides to next step in forgot password process (security question)
    @IBAction func goToSecurityQuestion(_ sender: Any) {
                
        if !usernameNextDisabled {
            
            // check for each user to get user's security question
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                
                if ((user?.username)?.lowercased() == forgetfulUser.lowercased() || (user?.email)?.lowercased() == forgetfulUser.lowercased()) {
                    securityQuestionLabel.text = user?.securityQuestion
                }
                
            }
            
            self.viewSlideInFromRight(view: securityQuestionView)
            securityQuestionView.isHidden = false
        }
        
    } // end goToSecurityQuestion
    
    
    // slides to next step in forgot password process (create new password)
    @IBAction func goToResetPassword(_ sender: Any) {
        
        if !securityNextDisabled {
            self.viewSlideInFromRight(view: resetPasswordView)
            resetPasswordView.isHidden = false
        }
        
    } // end goToResetPassword
    
    
    // changes user's password data and slides back to login screen
    @IBAction func resetPassword(_ sender: Any) {
        
        if !resetPasswordDisabled {
            // slide out of view and hide forgot password panel
            self.viewSlideCancel(view: forgotPasswordView)
            forgotPasswordView.isHidden = true
            
            // change the user's password on file
            if let index = (UIApplication.shared.delegate as! AppDelegate).userData.firstIndex(where: {$0?.username == forgetfulUsername}) {
                
                print("Forgetful User: \(forgetfulUser)")
                print("Forgetfuk Username: \(forgetfulUsername)")
                print("Current Password: \(currentPassword)")
                print("New Password: \(newPassword)")
                
                (UIApplication.shared.delegate as! AppDelegate).userData[index]?.password = newPassword
            
            }
            
            // DEBUGGING
            for user in (UIApplication.shared.delegate as! AppDelegate).userData {
                
                print("---------- USERS ON FILE (\((UIApplication.shared.delegate as! AppDelegate).userData.count)) ----------")
                print("Username: \(user!.username!)")
                print("Email: \(user!.email!)")
                print("Password: \(user!.password!)")
                print("Security Question: \(user!.securityQuestion!)")
                print("Security Answer: \(user!.securityAnswer!)")
                if (user?.savedSongs) != nil {
                    print("Saved Songs: \(user!.savedSongs)")
                }
                else {
                    print("Saved Songs: NONE")
                }
                print("-------------------------------------------------")
            }
            
            // clear the forgetfulUser's username
            forgetfulUser = ""
            
            // clear text fields in forgot password process and go back to
            // first page in forgot password process
            usernameEmailField.text = ""
            usernameEmailField.layer.borderWidth = 0.0
            forgotPasswordError.isHidden = true
            // second page in forgot password process
            securityAnswerField.text = ""
            securityAnswerField.layer.borderWidth = 0.0
            securityQuestionView.isHidden = true
            // third page in forgot password process
            createPasswordField.text = ""
            createPasswordField.layer.borderWidth = 0.0
            confirmPasswordField.text = ""
            confirmPasswordField.layer.borderWidth = 0.0
            resetPasswordView.isHidden = true
            resetPasswordErrorLabel.isHidden = true
            resetPasswordErrorLabel.font = resetPasswordErrorLabel.font.withSize(18)
            
            // disable next buttons and change alpha of next buttons
            usernameNextDisabled = true
            usernameNextButton.alpha = 0.7
            securityNextDisabled = true
            securityNextButton.alpha = 0.7
            resetPasswordDisabled = true
            resetPasswordButton.alpha = 0.7
            
            logo.alpha = 1.0
            orLeftLine.alpha = 1.0
            or.alpha = 1.0
            orRightLine.alpha = 1.0
            createAcctButton.alpha = 1.0
            createAcctButton.isEnabled = true
            
        } // end if reset password is not disabled
        
    } // end resetPassword
    
    
    // action for cancelling forgot password process
    @IBAction func cancelForgotPassword(_ sender: Any) {
        
        // clear the forgetfulUser's username
        forgetfulUser = ""
        
        // clear text fields in forgot password process and go back to
        // first page in forgot password process
        usernameEmailField.text = ""
        usernameEmailField.layer.borderWidth = 0.0
        forgotPasswordError.isHidden = true
        // second page in forgot password process
        securityAnswerField.text = ""
        securityAnswerField.layer.borderWidth = 0.0
        securityQuestionView.isHidden = true
        // third page in forgot password process
        createPasswordField.text = ""
        createPasswordField.layer.borderWidth = 0.0
        confirmPasswordField.text = ""
        confirmPasswordField.layer.borderWidth = 0.0
        resetPasswordView.isHidden = true
        resetPasswordErrorLabel.isHidden = true
        resetPasswordErrorLabel.font = resetPasswordErrorLabel.font.withSize(18)
        
        // disable next buttons and change alpha of next buttons
        usernameNextDisabled = true
        usernameNextButton.alpha = 0.7
        securityNextDisabled = true
        securityNextButton.alpha = 0.7
        resetPasswordDisabled = true
        resetPasswordButton.alpha = 0.7
        
        // slide out of view and hide forgot password panel
        self.viewSlideCancel(view: forgotPasswordView)
        forgotPasswordView.isHidden = true
        
        // login page items are more visible
        logo.alpha = 1.0
        orLeftLine.alpha = 1.0
        or.alpha = 1.0
        orRightLine.alpha = 1.0
        createAcctButton.alpha = 1.0
        createAcctButton.isEnabled = true
        
    } // end cancel forgot password
    
    
    
    
    
    // -------------- KEYBOARD DISMISSAL -----------------
    
    // dismiss keyboard on tap anywhere
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        loginView.endEditing(true)
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    } // end dismiss keyboard
    
    
    
    
    
    // ---------------- SEGUE PREPARE -----------------
    
    // prepare to send data to home page on successful login
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var name:String = ""
        var email:String = ""
        var passwordCount:Int = 0
        loginViewCount = -999
        
        print("(\((UIApplication.shared.delegate as! AppDelegate).userData.count))")
        
        for user in (UIApplication.shared.delegate as! AppDelegate).userData {
            if (user?.username)?.lowercased() == (usernameField.text)?.lowercased() || (user?.email)?.lowercased() == (usernameField.text?.lowercased()) {
                name = user!.username!
                email = user!.email!
                passwordCount = user!.password!.count
            }
        }
        
        if segue.identifier == "loginToHome" {
            let destination = segue.destination as! HomeController
            destination.users_name = name
            destination.users_email = email
            destination.users_password_count = passwordCount
        }
        
    } // end prepare for segue
    
    
    
    
    
    // -------------------- ANIMATIONS ----------------------
    
    // slide from top animation for forgot password
    func viewSlideInFromTop(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideInFromTop()
    
    
    // slide from right animation for forgot password process
    func viewSlideInFromRight(view: UIView) -> Void {
        view.isHidden = false
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideInFromRight()
    
    
    // slide from top animation for cancel create account
    func viewSlideCancel(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.layer.add(transition, forKey: kCATransition)
    }   // end viewSlideCancel()
    
    
    
}   // end LoginController

