//
//  FLUserManager.h
//  fitlog
//
//  Created by B.J. Ray on 2/7/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLLoginDelegate.h"
@class  FLUser;
@class FLActivityType;

@interface FLUserManager : NSObject

+(instancetype)sharedManager;

@property (nonatomic, retain) FLUser *user;
@property (weak, nonatomic) id<FLLoginDelegate> delegate;


- (BOOL)checkAuthentication;
//- (void)openFacebookSession;
- (void)saveFavorites:(NSArray *)favorites;
- (void)saveActivity:(FLActivityType *)activity forDate:(NSDate *)date;
//- (void)saveSession
- (void)logoutUser;


@end
