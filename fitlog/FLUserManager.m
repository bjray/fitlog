//
//  FLUserManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/7/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLUserManager.h"
#import "StackMob.h"
#import "User.h"

@implementation FLUserManager


- (void)checkAuthentication {
    
}


//- (void)sessionStateChanged:(FBSession *)session
//                      state:(FBSessionState) state
//                      error:(NSError *)error
//{
//    switch (state) {
//        case FBSessionStateOpen:
//            [self loginUser];
//            break;
//        case FBSessionStateClosed:
//            [FBSession.activeSession closeAndClearTokenInformation];
//            [self updateView];
//            break;
//        case FBSessionStateClosedLoginFailed:
//            [FBSession.activeSession closeAndClearTokenInformation];
//            break;
//        default:
//            break;
//    }
//    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:SCSessionStateChangedNotification
//     object:session];
//    
//    if (error) {
//        //TODO: Handle error...
//    }
//}

- (void)loginUser {
    
}

- (void)logoutUser {
    
}
@end
