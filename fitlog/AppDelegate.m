//
//  AppDelegate.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "AppDelegate.h"
#import "FLUser.h"
#import "FLActivityType.h"

#define FB_APP_ID @"9ILuGQbYRPPCjss1Y1yPnto5MLjxz1iYshSc5Fz8"
#define FB_CLIENT_KEY @"seD1rhtS5UjYI6hsJWLORZ6aDhlyaDNnHoGivEXL"

#define TW_CONSUMER_KEY @"obowSmqbwl11dS09Iuc1Dw"
#define TW_CONSUMER_SECRET @"tVlfTk1FzlRN7zAAn9DYNd8mSImxWBCJctLRXBNN0U"

@interface AppDelegate()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeParseObjects];
    [Parse setApplicationId:FB_APP_ID clientKey:FB_CLIENT_KEY];
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:TW_CONSUMER_KEY consumerSecret:TW_CONSUMER_SECRET];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];

}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Facebook oauth callback


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)initializeParseObjects {
    [FLUser registerSubclass];
    [FLActivityType registerSubclass];
}

@end
