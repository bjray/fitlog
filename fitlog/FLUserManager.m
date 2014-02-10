//
//  FLUserManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/7/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLUserManager.h"
#import "StackMob.h"
#import "AppDelegate.h"
#import "User.h"
#import "FBSession.h"
#import "FBRequest.h"
#import "FBAccessTokenData.h"
#import "FBGraphUser.h"

@interface FLUserManager()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
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
        self.managedObjectContext = [[[SMClient defaultClient] coreDataStore] contextForCurrentThread];
//        self.user = [[User alloc] init];
    }
    return self;
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)checkAuthentication {
    BOOL result = NO;
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        //if token loaded, attempt to login...
        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self sessionStateChanged:session state:status error:error];
        }];
        result = YES;
        //from here, we should try and retrieve user object, right?
    } else {
        //not authenticated - notify delegate...
        result = NO;
    }
    return result;
}




//attempt to connect with FB
- (void)openFacebookSession
{
    NSArray *permissions = [NSArray arrayWithObjects:@"user_photos",
                            nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

#pragma mark - Private Methods

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            [self loginUser];
            //TODO: handle login
            break;
        case FBSessionStateClosed:
            [FBSession.activeSession closeAndClearTokenInformation];
            //TODO: Handle closed session...
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }

    //can post FB Session object if we need to...
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:SCSessionStateChangedNotification
//     object:session];
    
    if (error) {
        //TODO: Handle error...
    }
}

/*
 Initiate a request for the current Facebook session user info, and apply the username to
 the StackMob user that might be created if one doesn't already exist.  Then login to StackMob with Facebook credentials.
 */
- (void)loginUser {
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             [[self appDelegate].client loginWithFacebookToken:FBSession.activeSession.accessTokenData.accessToken createUserIfNeeded:YES usernameForCreate:user.username onSuccess:^(NSDictionary *result) {
                 NSLog(@"Logged in with StackMob");
                 [self updateUserObjectWithDictionary:result];
                 [self.delegate successfulAuthentication];
             } onFailure:^(NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
         } else {
             // Handle error accordingly
             NSLog(@"Error getting current Facebook user data, %@", error);
         }
         
     }];
}

- (void)logoutUser {
    [[self appDelegate].client logoutOnSuccess:^(NSDictionary *result) {
        NSLog(@"Logged out of StackMob");
        [FBSession.activeSession closeAndClearTokenInformation];
//        self.user = [[User alloc] init];
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) updateUserObjectWithDictionary:(NSDictionary *) userDict {
    NSString *username = [userDict objectForKey:@"username"];
    
    NSFetchRequest *userFetch = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    [userFetch setPredicate:[NSPredicate predicateWithFormat:@"username == %@",username]];
    
    NSManagedObjectContext *context = [[self appDelegate].coreDataStore contextForCurrentThread];
    [context executeFetchRequest:userFetch onSuccess:^(NSArray *results) {
        if ([results count] != 1) {
            NSLog(@"wait!  why is there more than one?");
        } else {
            self.user = (User *)[results objectAtIndex:0];
//            self.user.isAuthenticated = YES;
        }
    } onFailure:^(NSError *error) {
        NSLog(@"an error occurred");
    }];
    
    NSLog(@"where are we now?");
}
@end
