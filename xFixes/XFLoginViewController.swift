//
//  XFLoginViewController.swift
//  xFixes
//
//  Created by Ryad on 23.07.17.
//  Copyright © 2017 Ryad. All rights reserved.
//

import UIKit

class XFLoginViewController: UIViewController {

	/*
    @IBAction func loginButton(_ sender: Any) {
        if usernameLabel.text == "Ryad" && passwordLabel.text == "0000" {
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        } else {
            usernameLabel.backgroundColor = UIColor.red
            passwordLabel.backgroundColor = UIColor.red
        }
    }*/
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hue: 210/360, saturation: 0/100, brightness: 90/100, alpha: 1.0)
    }

}
