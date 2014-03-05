//
//  FLActivityManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityManager.h"
#import "FLActivityType.h"
#import "FLActivity.h"

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

- (BOOL)isFavoriteActivity:(FLActivityType *)activity within:(NSArray *)favorites {
    BOOL result = NO;
    
    for (FLActivityType *anActivity in favorites) {
        if ([anActivity isEqualToActivity:activity]) {
            result = YES;
            break;
        }
    }
    return result;
}

- (FLActivityType *)findActivityTypeFromActivities:(NSArray *)activities byName:(NSString *)name {
    FLActivityType *result = nil;
    for (FLActivityType *activityType in activities) {
        if ([activityType.name isEqualToString:name]) {
            result = activityType;
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
        PFQuery *query = [relation query];
        [self cachePolicyForQuery:query];
        //[[relation query] findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
            if (!error) {
                [subscriber sendNext:favorites];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                [subscriber sendError:error];
//                kPFErrorCacheMiss
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

- (RACSignal *)removeFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"attempt to remove object for user...");
        
        //Check out: https://www.parse.com/questions/pfrelation-removeobject-deletes-actual-object-not-relationship
        //remove object from relation
        // And then save data via relation again???
        PFRelation *relation = [[PFUser currentUser] relationForKey:FL_FAV_RELATION];
        [relation removeObject:activity];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];

        return [RACDisposable disposableWithBlock:^{
            NSLog(@"nothing to dispose of...");
        }];
        
        
    }];
}

- (RACSignal *)saveActivity:(FLActivity *)activity forUser:(PFUser *)user {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"activity: %@", activity);
        //could move this behind an api...
        PFObject *pfActivity = [PFObject objectWithClassName:@"Activity"];
        pfActivity[@"name"] = activity.name;
        pfActivity[@"comment"] = activity.comment;
        pfActivity[@"repeats"] = [NSNumber numberWithInteger:activity.repeats];
        pfActivity[@"completionDate"] = activity.completionDate;
        pfActivity[@"duration"] = [NSNumber numberWithFloat:activity.duration];
        pfActivity[@"activityType"] = [PFObject objectWithoutDataWithClassName:@"ActivityType" objectId:activity.activityTypeId];
        
        [pfActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
//        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"nothing to dispose of");
        }];
    }];
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


- (void)cachePolicyForQuery:(PFQuery *)aQuery {
    if ([aQuery hasCachedResult]) {
        aQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        NSLog(@"pull from cache first");
    } else {
        aQuery.cachePolicy = kPFCachePolicyNetworkOnly;
        NSLog(@"no cache - pull from network");
    }
    
    aQuery.maxCacheAge = 60 * 60 * 24; //one day
}



@end
