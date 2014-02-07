//
//  FLUserManager.h
//  fitlog
//
//  Created by B.J. Ray on 2/7/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  User;

@interface FLUserManager : NSObject
@property (nonatomic, retain) User *user;

- (void)checkAuthentication;

@end
