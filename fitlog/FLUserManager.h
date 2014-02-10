//
//  FLUserManager.h
//  fitlog
//
//  Created by B.J. Ray on 2/7/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLLoginDelegate.h"
@class  User;
@class Activity_Type;

@interface FLUserManager : NSObject

+(instancetype)sharedManager;

@property (nonatomic, retain) User *user;
@property (weak, nonatomic) id<FLLoginDelegate> delegate;


- (BOOL)checkAuthentication;
- (void)openFacebookSession;
- (void)saveFavorites:(NSArray *)favorites;
- (void)saveActivity:(Activity_Type *)activity forDate:(NSDate *)date;
//- (void)saveSession
- (void)logoutUser;


@end
