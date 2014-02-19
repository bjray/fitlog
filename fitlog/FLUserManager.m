//
//  FLUserManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/7/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLUserManager.h"
#import "FLUser.h"
#import "AppDelegate.h"

@interface FLUserManager()
@property (nonatomic, retain, readwrite) FLUser *user;
@end

@implementation FLUserManager

#pragma mark - Public Methods...
+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        
    });
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Public Methods



#pragma mark - Helper Methods

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (BOOL)checkAuthentication {
    BOOL result = NO;
    NSLog(@"check authentication");
    return result;
}


- (void)saveFavorites:(NSArray *)favorites {
    NSLog(@"Save favorites");
}

//- (void)saveActivity:(FLActivityType *)activity forDate:(NSDate *)date {
//    NSLog(@"saving activity");
//}



#pragma mark - Private Methods

- (void)loginUser {
    
    NSLog(@"login user");
}

- (void)logoutUser {
    NSLog(@"logout user");
}

- (void) updateUserObjectWithDictionary:(NSDictionary *) userDict {
    NSLog(@"Extract user info");
}
@end
