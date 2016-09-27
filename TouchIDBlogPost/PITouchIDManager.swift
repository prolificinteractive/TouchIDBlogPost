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

    func authenticateUser(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        // Get the current authentication context
        let context = LAContext()
        var error: NSError?
        let myLocalizedReasonString = "Authentification is required"

        // Check if the device is compatible with TouchID and can evaluate the policy.
        guard context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async {
                failure(error!)
            }
            return
        }

        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: myLocalizedReasonString,
                               reply: { (status: Bool, evaluationError: NSError?) -> Void in
                                if status {
                                    DispatchQueue.main.async {
                                        success()
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        failure(evaluationError!)
                                    }
                                }
                                } as! (Bool, Error?) -> Void)
        
    }
    
    func fetchImage(failure fail : ((NSError) -> ())? = nil,
                    success succeed: ((UIImage) -> ())? = nil) {
        
    }
    
}
