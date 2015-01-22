//
//  PITouchIDManager.h
//  TouchIDBlogPost
//
//  Created by Thibault Klein on 12/11/14.
//  Copyright (c) 2014 Prolific Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PITouchIDManager : NSObject

+ (void)authenticateUserWithSuccess:(void (^)(BOOL result))successBlock
                            failure:(void (^)(NSError *error))failureBlock;

@end
