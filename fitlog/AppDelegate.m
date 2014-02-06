//
//  AppDelegate.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "AppDelegate.h"
#import "StackMob.h"

#define PUBLIC_KEY @"0e015430-7c84-4bb3-b25d-e2519ed706bb"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    SM_CACHE_ENABLED = YES;
    
    self.client = [[SMClient alloc] initWithAPIVersion:@"0" publicKey:PUBLIC_KEY];
    self.coreDataStore = [ self.client coreDataStoreWithManagedObjectModel:self.managedObjectModel];
    

    [self.coreDataStore setFetchPolicy:SMFetchPolicyCacheOnly];
    
    __block SMCoreDataStore *blockCoreDataStore = self.coreDataStore;
    
    
    [self.client.networkMonitor setNetworkStatusChangeBlock:^(SMNetworkStatus status) {
        if (status == SMNetworkStatusReachable) {
            // Initiate sync
            [blockCoreDataStore syncWithServer];
        }
        else {
            // Handle offline mode
            [blockCoreDataStore setFetchPolicy:SMFetchPolicyCacheOnly];
        }
    }];
    
    [self.coreDataStore setSyncCompletionCallback:^(NSArray *objects) {
        NSLog(@"Sync complete.");
        // Our syncing is complete, so change the policy to fetch from the network
        [blockCoreDataStore setFetchPolicy:SMFetchPolicyTryNetworkElseCache];
        
        // Notify other views that they should reload their data from the network
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedSync" object:nil];
    }];
    
    [self.coreDataStore setSyncCallbackForFailedInserts:^(NSArray *objects) {
        NSLog(@"Sync Failure on Inserts");
    }];
    
    [self.coreDataStore setSyncCallbackForFailedUpdates:^(NSArray *objects) {
        NSLog(@"Sync Failure on Updates");
    }];
    
    [self.coreDataStore setSyncCallbackForFailedDeletes:^(NSArray *objects) {
        NSLog(@"Sync Failure on Deletes");
    }];
    return YES;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"fitlog" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
