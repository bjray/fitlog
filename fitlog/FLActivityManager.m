//
//  FLActivityManager.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityManager.h"
#import "FLActivityType.h"
#import "FLUserManager.h"
#import "FLUser.h"

@interface FLActivityManager()
@property (strong, nonatomic, readwrite) NSArray *activityTypes;
@property (nonatomic, strong, readwrite) NSArray *favoriteActivitiesTypes;

//TODO: Temp to simulate selection and deselection of favorites...
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
        self.favoriteTypes = [NSMutableArray array];
        self.activityTypes = [NSArray array];
        
    }
    
    return self;
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

- (void)fetchFavoriteActivities {
    //awkward, i know...
    //TODO: Replace with real fetch logic...
    
    int r = arc4random() % 3;
    switch (r) {
        case 0:
            self.favoriteActivitiesTypes = @[@"Push-ups",@"Abs", @"Pull-ups"];
            break;
        case 1:
            self.favoriteActivitiesTypes = @[@"Running",@"Boxing",@"Mini Murph",@"Sprint - ladders",@"Cycling",@"Hill Repeats",@"Abs"];
            break;
        case 2:
            self.favoriteActivitiesTypes = @[@"Windy walks",@"Skipping",@"Tickle Fights"];
            break;
        case 3:
            self.favoriteActivitiesTypes = @[@"Lift Weights",@"Break dancing",@"Wrestling",@"Screaming", @"Jump Rope",@"Farm lovin",@"Slap Ass"];
            break;
        default:
            break;
    }
    
    
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
