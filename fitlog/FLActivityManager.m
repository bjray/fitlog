//
//  FLActivityManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityManager.h"
#import "FLActivityType.h"
//#import "FLUserManager.h"
//#import "FLUser.h"

@interface FLActivityManager()
@property (strong, nonatomic, readwrite) NSArray *activityTypes;
@property (nonatomic, strong, readwrite) NSArray *favoriteActivityTypes;

//TODO: Temp to simulate selection and deselection of favorites...
//@property (strong, nonatomic) NSMutableArray *favoriteTypes;

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
//        self.favoriteTypes = [NSMutableArray array];
        self.activityTypes = [NSArray array];
        
    }
    
    return self;
}

- (BOOL)isFavoriteAtIndexPath:(NSIndexPath *) indexPath {
    FLActivityType *atype = [self.activityTypes objectAtIndex:indexPath.row];
    BOOL result = NO;
    
    result = [self.favoriteActivityTypes containsObject:atype];
    return result;
}

- (NSString *)nameAtIndexPath:(NSIndexPath *) indexPath {
    FLActivityType *atype = [self.activityTypes objectAtIndex:indexPath.row];
    return atype.name;
}

- (NSString *)idAtIndexPath:(NSIndexPath *) indexPath {
    FLActivityType *atype = [self.activityTypes objectAtIndex:indexPath.row];
    return atype.objectId;
}

- (NSNumber *)itemCount {
    return [NSNumber numberWithInteger:[self.activityTypes count]];
}

//- (void)tableViewCell:(UITableViewCell *)cell toggleFavoriteAtIndexPath:(NSIndexPath *)indexPath {
//    BOOL isFavorite = [self.favoriteTypes containsObject:[self.activityTypes objectAtIndex:indexPath.row]];
//    if (isFavorite) {
//        //remove from favorite
//        [self.favoriteTypes removeObject:[self.activityTypes objectAtIndex:indexPath.row]];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        // add to favorites
//        [self.favoriteTypes addObject:[self.activityTypes objectAtIndex:indexPath.row]];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//}


#pragma mark - Data Requests...

// Only pull active ActivityTypes...
- (void)fetchAllActivityTypes {
    PFQuery *query = [PFQuery queryWithClassName:@"ActivityType"];
    [query whereKey:@"isActive" equalTo:@YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"retrieved %d activity types", [objects count]);
            self.activityTypes = objects;
        } else {
            NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
        }
    }];
    
}
- (void)fetchFavoriteActivitiesForUser:(PFUser *)user {
    NSMutableArray *favs = [NSMutableArray array];
    PFQuery *query = [PFQuery queryWithClassName:FL_FAVORITE];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //do I respond with a signal here?
            NSLog(@"successfully retrieved favorites");
            for (PFObject *object in objects) {
                
                FLActivityType *activity = [self activityTypeFromFavorite:object];
                NSLog(@"Fave activity: %@", activity.name);
                if (activity) {
                    [favs addObject:activity];
                }
            }
            self.favoriteActivityTypes = [NSArray arrayWithArray:favs];
        } else {
            //need to shoot a signal back...
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)fetchFavoriteActivities {
    //awkward, i know...
    //TODO: Replace with real fetch logic...
    self.favoriteActivityTypes = nil;
    
//    int r = arc4random() % 3;
//    switch (r) {
//        case 0:
//            self.favoriteActivityTypes = @[@"Push-ups",@"Abs", @"Pull-ups"];
//            break;
//        case 1:
//            self.favoriteActivityTypes = @[@"Running",@"Boxing",@"Mini Murph",@"Sprint - ladders",@"Cycling",@"Hill Repeats",@"Abs"];
//            break;
//        case 2:
//            self.favoriteActivityTypes = @[@"Windy walks",@"Skipping",@"Tickle Fights"];
//            break;
//        case 3:
//            self.favoriteActivityTypes = @[@"Lift Weights",@"Break dancing",@"Wrestling",@"Screaming", @"Jump Rope",@"Farm lovin",@"Slap Ass"];
//            break;
//        default:
//            break;
//    }
    
    
}

- (RACSignal *)saveFavoriteActivityAtIndex:(NSUInteger)index forUser:(PFUser *)user {
    FLActivityType *activity = [self.activityTypes objectAtIndex:index];
    if (activity) {
        return [self saveFavoriteActivity:activity forUser:user];
    } else {
        NSLog(@"Object does not exist");
        return nil;
    }
}

- (RACSignal *)saveFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"save favorite: %@ for user: %@", activity.name, user.username);
        
        NSString *objectId = [self objectIdForActivity:activity inFavoriteList:self.favoriteActivityTypes];
        if (!objectId) {
            PFObject *newFavorite = [self createFavoriteForActivity:activity forUser:user];
            [newFavorite saveEventually:^(BOOL succeeded, NSError *error) {
                NSLog(@"let the controller know that the save occurred!");
                if (succeeded) {
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:error];
                }
            }];
        } else {
            NSLog(@"favorite already exists for this user - take no action");
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

- (BOOL)removeFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user {
    BOOL result = NO;
    
    return result;
}

#pragma mark - Helper Methods...

// Creates a Favorite object type
- (PFObject *)createFavoriteForActivity:(FLActivityType *)activity forUser:(PFUser *)user {
    PFObject *newFavorite = [PFObject objectWithClassName:FL_FAVORITE];
    
    [newFavorite setObject:activity forKey:@"activityType"];
    [newFavorite setObject:user forKey:@"user"];
    
    return newFavorite;
}

// Use this to get the objectId of an Activity out of the favorite list, if one exists...
- (NSString *)objectIdForActivity:(FLActivityType *)activity inFavoriteList:(NSArray *)favorties {
    NSString *objectId = nil;
    NSLog(@"called objectIdForActivity:inFavoriteList:");
    for (FLActivityType *aFavActivity in self.favoriteActivityTypes) {
        if ([aFavActivity.objectId isEqualToString:activity.objectId]) {
            objectId = aFavActivity.objectId;
            NSLog(@"Found object id: %@", objectId);
            break;
        }
    }
    
    return objectId;
}

// This method extracts an Activity from a Favorite PFObject type.  This object has parameters: activityType and user
- (FLActivityType *)activityTypeFromFavorite:(PFObject *)favorite {
    
    //Parse doesn't return a fully-built Activity object...
    FLActivityType *shell = [favorite objectForKey:@"activityType"];
    FLActivityType *activity = nil;
    
    for (FLActivityType *type in self.activityTypes) {
        if ([type.objectId isEqualToString:shell.objectId]) {
            activity = type;
            break;
        }
    }
    return activity;
}



- (RACSignal *)objectIdForActivity:(FLActivityType *) activity andUser:(PFUser *)user {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PFQuery *query = [PFQuery queryWithClassName:FL_FAVORITE];
        [query whereKey:@"activityType" equalTo:activity];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d favorites.", objects.count);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                }
                [subscriber sendNext:[objects objectAtIndex:0]];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                [subscriber sendError:error];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"clean up destroued signal - anything to clean?");
        }];

    }] doError:^(NSError *error) {
         NSLog(@"signal error: %@", [error localizedDescription]);
    }];
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
