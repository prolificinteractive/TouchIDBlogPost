//
//  ViewController.swift
//  TouchIDBlogPost
//
//  Created by Thibault Klein on 10/13/14.
//  Copyright (c) 2014 Prolific Interactive. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        authenticateUser()
    }


    func setupData() {
        self.statusLabel.text = "Unknown user"
    }

    func authenticateUser() {
        let touchIDManager : PITouchIDManager = PITouchIDManager()

        touchIDManager.authenticateUser(success: { () -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.loadDada()
            })
            }, failure: { (evaluationError: NSError) -> () in
                switch evaluationError.code {
                case LAError.SystemCancel.rawValue:
                    print("Authentication cancelled by the system")
                    self.statusLabel.text = "Authentication cancelled by the system"
                case LAError.UserCancel.rawValue:
                    print("Authentication cancelled by the user")
                    self.statusLabel.text = "Authentication cancelled by the user"
                case LAError.UserFallback.rawValue:
                    print("User wants to use a password")
                    self.statusLabel.text = "User wants to use a password"
                    // We show the alert view in the main thread (always update the UI in the main thread)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showPasswordAlert()
                    })
                case LAError.TouchIDNotEnrolled.rawValue:
                    print("TouchID not enrolled")
                    self.statusLabel.text = "TouchID not enrolled"
                case LAError.PasscodeNotSet.rawValue:
                    print("Passcode not set")
                    self.statusLabel.text = "Passcode not set"
                default:
                    print("Authentication failed")
                    self.statusLabel.text = "Authentication failed"
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showPasswordAlert()
                    })
                }
        })
    }

    func loadDada() {
        self.statusLabel.text = "User authenticated"
    }

    func showPasswordAlert() {
        // New way to present an alert view using UIAlertController
        let alertController : UIAlertController = UIAlertController(title:"TouchID Demo" , message: "Please enter password", preferredStyle: .Alert)

        // We define the actions to add to the alert controller
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print(action)
        }
        let doneAction : UIAlertAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            if let text = passwordTextField.text {
                self.login(text)
            }
        }
        doneAction.enabled = false

        // We are customizing the text field using a configuration handler
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true

            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                doneAction.enabled = textField.text != ""
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)

        self.presentViewController(alertController, animated: true) {
            // Nothing to do here
        }
    }

    func login(password: String) {
        if password == "prolific" {
            self.loadDada()
        } else {
            self.showPasswordAlert()
        }
    }

}

