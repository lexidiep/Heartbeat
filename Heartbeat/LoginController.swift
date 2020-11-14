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
    
    // variables
    // struct for saved songs by user
    struct saved {
        var title:String?
        var artist: String?
        var id:String?
    }
    // struct for individual user data
    struct userInfo {
        var firstName: String?
        var lastName: String?
        var email:String?
        var password:String?
        var username:String?
        var savedSongs:[saved?]
        var securityAnswer: String?
    }
    var users = [userInfo?]()   // array of structs used to store user information
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        createAcctButton.layer.cornerRadius = 5
        
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username or email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

}

