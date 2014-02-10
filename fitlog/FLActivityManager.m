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

@interface FLActivityManager()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *activityTypes;
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

- (NSInteger)itemCount {
    return [self.activityTypes count];
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

- (void)commitTransactions {
    
}


#pragma mark - Data Requests...
//TODO: Extract the datasource outside the controller...
- (void)getAllActivityTypes {
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Activity_Type"];
    [self.managedObjectContext executeFetchRequest:fetch onSuccess:^(NSArray *results) {
        
        self.activityTypes = results;
//        self.favoriteTypes = [NSMutableArray array];
        //TODO: Remove after signals are added...
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedFetch" object:nil];
    } onFailure:^(NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}
@end
