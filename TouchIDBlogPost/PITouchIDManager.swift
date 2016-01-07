//
//  PITouchIDManager.swift
//  TouchIDBlogPost
//
//  Created by Thibault Klein on 12/11/14.
//  Copyright (c) 2014 Prolific Interactive. All rights reserved.
//

import UIKit
import LocalAuthentication

class PITouchIDManager {

    // See style guide for functions with closure parameters in Swift
    // https://github.com/hpique/Articles/blob/master/Swift/Style%20guide%20for%20functions%20with%20closure%20parameters/Style%20guide%20for%20functions%20with%20closure%20parameters.md

    func authenticateUser(success succeed: (() -> ())? = nil, failure fail: (NSError -> ())? = nil) {
        if fail == nil && succeed == nil { return }

        // Get the current authentication context
        let context : LAContext = LAContext()
        var error : NSError?
        let myLocalizedReasonString : NSString = "Authentification is required"

        // Check if the device is compatible with TouchID and can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString as String, reply: { (success : Bool, evaluationError : NSError?) -> Void in
                if success {
                    if let succeed = succeed {
                        dispatch_async(dispatch_get_main_queue()) {
                            succeed()
                        }
                    }
                } else {
                    if let fail = fail {
                        dispatch_async(dispatch_get_main_queue()) {
                            fail(evaluationError!)
                        }
                    }
                }
            })
        } else {
            if let fail = fail {
                dispatch_async(dispatch_get_main_queue()) {
                    fail(error!)
                }
            }
        }
    }

    func fetchImage(failure fail : (NSError -> ())? = nil,
        success succeed: (UIImage -> ())? = nil) {
            
    }

}
