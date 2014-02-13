//
//  FLActivityManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityManager.h"
#import <CoreData/CoreData.h>
#import "StackMob.h"
#import "Activity_Type.h"
#import "FLUserManager.h"
#import "User.h"

@interface FLActivityManager()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic, readwrite) NSArray *activityTypes;
@property (strong, nonatomic) NSMutableArray *favoriteTypes;

@end

@implementation FLActivityManager

#pragma mark - Public Interface

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
        self.favoriteTypes = [NSMutableArray array];
        self.activityTypes = [NSArray array];
        
    }
    
    return self;
}

- (NSString *)nameAtIndexPath:(NSIndexPath *) indexPath {
    Activity_Type *atype = [self.activityTypes objectAtIndex:indexPath.row];
    return atype.name;
}

- (NSString *)idAtIndexPath:(NSIndexPath *) indexPath {
    Activity_Type *atype = [self.activityTypes objectAtIndex:indexPath.row];
    return atype.activity_type_id;
}

- (NSNumber *)itemCount {
    return [NSNumber numberWithInteger:[self.activityTypes count]];
}

- (void)tableViewCell:(UITableViewCell *)cell toggleFavoriteAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isFavorite = [self.favoriteTypes containsObject:[self.activityTypes objectAtIndex:indexPath.row]];
    if (isFavorite) {
        //remove from favorite
        [self.favoriteTypes removeObject:[self.activityTypes objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        // add to favorites
        [self.favoriteTypes addObject:[self.activityTypes objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


#pragma mark - Data Requests...
//TODO: Extract the datasource outside the controller...
- (void)fetchAllActivityTypes {
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Activity_Type"];
    [self.managedObjectContext executeFetchRequest:fetch onSuccess:^(NSArray *results) {
        
        self.activityTypes = results;
        //TODO: temporary...
        [self fetchFavoriteActivities];
    } onFailure:^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

- (void)fetchFavoriteActivities {
    //awkward, i know...
    User *user = [FLUserManager sharedManager].user;
    NSLog(@"# of user favorites: %d", [user.favorites count]);
}


//This will be used along with the method to fetch favorites and return as a single signal...maybe
//- (RACSignal *)fetchAllActivityTypes {
//    NSLog(@"fetching activity types...");
//    
//    //return a signal object - won't create a signal until someone subscribes to it...
//    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//
//        //go get the data from SM
//        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Activity_Type"];
//        [self.managedObjectContext executeFetchRequest:fetch onSuccess:^(NSArray *results) {
//            
//            [subscriber sendNext:results];
//
//        } onFailure:^(NSError *error) {
//            [subscriber sendError:error];
//            NSLog(@"Error: %@", [error localizedDescription]);
//        }];
//        
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"clean up destroyed singal - anything to clean?");
//        }];
//    }] doError:^(NSError *error) {
//        NSLog(@"signal error: %@", [error localizedDescription]);
//    }];
//}

@end
