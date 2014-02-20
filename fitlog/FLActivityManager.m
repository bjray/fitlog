//
//  FLActivityManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityManager.h"
#import "FLActivityType.h"

@interface FLActivityManager()
@property (strong, nonatomic, readwrite) NSArray *activityTypes;
@property (nonatomic, strong, readwrite) NSArray *favoriteActivityTypes;


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
        
    }
    
    return self;
}

//- (BOOL)isFavoriteAtIndexPath:(NSIndexPath *) indexPath {
//    BOOL result = NO;
//    FLActivityType *atype = [self.activityTypes objectAtIndex:indexPath.row];
//    
//    result = [self.favoriteActivityTypes containsObject:atype];
//    if (result) {
////        NSLog(@"Found %@ as a favorite!", atype);
//        NSLog(@"is a fav");
//    } else {
//        NSLog(@"not a fav");
//    }
//    return result;
//}
//
//
//- (NSString *)nameAtIndexPath:(NSIndexPath *) indexPath {
//    FLActivityType *atype = [self.activityTypes objectAtIndex:indexPath.row];
//    return atype.name;
//}
//
//
//- (NSString *)idAtIndexPath:(NSIndexPath *) indexPath {
//    FLActivityType *atype = [self.activityTypes objectAtIndex:indexPath.row];
//    return atype.objectId;
//}
//
//- (NSNumber *)itemCount {
//    return [NSNumber numberWithInteger:[self.activityTypes count]];
//}

- (BOOL)isFavoriteActivity:(FLActivityType *)activity within:(NSArray *)favorites {
    BOOL result = NO;
    
    for (FLActivityType *anActivity in favorites) {
        if ([anActivity.objectId isEqualToString:activity.objectId]) {
            result = YES;
            break;
        }
    }
    return result;
}


#pragma mark - Data Requests...

// Only pull active ActivityTypes...
- (RACSignal *)fetchAllActivityTypes {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"ActivityType"];
        [query whereKey:@"isActive" equalTo:@YES];
        [self cachePolicyForQuery:query];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"retrieved %d activity types", [objects count]);
                [subscriber sendNext:objects];
            } else {
                NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"No clean up here.");
        }];
    }];
}


- (RACSignal *)fetchFavoriteActivitiesForUser:(PFUser *)user {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        PFRelation *relation = [user relationForKey:FL_FAV_RELATION];
        [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
            if (!error) {
                [subscriber sendNext:favorites];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                [subscriber sendError:error];
            }
            
        }];
    
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposal of fetching fav activities");
        }];
    }];
}



- (RACSignal *)saveFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"save favorite: %@ for user: %@", activity.name, user.username);
        
        NSString *objectId = [self objectIdForActivity:activity inFavoriteList:self.favoriteActivityTypes];
        if (!objectId) {
            
            PFRelation *relation = [user relationForKey:@"likes"];
            [relation addObject:activity];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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

//- (RACSignal *)removeFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user {
//    
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"attempt to remove object for user...");
//        
//        
//        PFQuery *query = [PFQuery queryWithClassName:FL_FAVORITE];
//        [query whereKey:@"activityType" equalTo:activity];
//        [query whereKey:@"user" equalTo:user];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (!error) {
//                // The find succeeded.
//                NSLog(@"Successfully retrieved %d scores.", objects.count);
//                // Do something with the found objects
//                for (PFObject *object in objects) {
//                    NSLog(@"%@", object.objectId);
//                }
//            } else {
//                // Log details of the failure
//                NSLog(@"Error: %@ %@", error, [error userInfo]);
//            }
//        }];
//        
//        
//    }];
//}

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


- (void)cachePolicyForQuery:(PFQuery *)aQuery {
    aQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    aQuery.maxCacheAge = 60 * 60 * 24; //one day
}



@end
