//
//  PITouchIDManager.m
//  TouchIDBlogPost
//
//  Created by Thibault Klein on 12/11/14.
//  Copyright (c) 2014 Prolific Interactive. All rights reserved.
//

#import "PITouchIDManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation PITouchIDManager

+ (void)authenticateUserWithSuccess:(void (^)(BOOL result))successBlock
                            failure:(void (^)(NSError *error))failureBlock {
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"String explaining why app needs authentication";

    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply: ^(BOOL success, NSError *error) {
                                if (success) {
                                    if (successBlock) {
                                        successBlock(success);
                                    }
                                }
                                else {
                                    if (failureBlock) {
                                        failureBlock(error);
                                    }
                                }
                            }];
    }
    else {
        failureBlock(authError);
    }
}

@end
