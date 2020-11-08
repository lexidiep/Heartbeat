//
//  LoginController.swift
//  Heartbeat
//
//  Created by Heartbeat on 10/11/20.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAcctButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        createAcctButton.layer.cornerRadius = 5
    }


}

