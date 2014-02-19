//
//  FLActivityManager.h
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
@class FLActivityType;

#define FL_FAVORITE @"Favorite"

@interface FLActivityManager : NSObject
@property (nonatomic, strong, readonly) NSArray *activityTypes;
@property (nonatomic, strong, readonly) NSArray *favoriteActivityTypes;

+(instancetype)sharedManager;

- (NSString *)nameAtIndexPath:(NSIndexPath *) indexPath;
- (NSString *)idAtIndexPath:(NSIndexPath *) indexPath;
- (NSNumber *)itemCount;
- (BOOL)isFavoriteAtIndexPath:(NSIndexPath *) indexPath;

- (void)fetchAllActivityTypes;
- (void)fetchFavoriteActivities;
- (void)fetchFavoriteActivitiesForUser:(PFUser *)user;
//- (RACSignal *)saveFavorite:(Activity_Type *)activity;

//- (RACSignal *)fetchAllActivityTypes;
//- (void)tableViewCell:(UITableViewCell *)cell toggleFavoriteAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)saveFavoriteActivityList:(NSArray *)favorites forUser:(FLUser *)user;
- (RACSignal *)saveFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user;
- (RACSignal *)saveFavoriteActivityAtIndex:(NSUInteger)index forUser:(PFUser *)user;
- (BOOL)removeFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user;
@end
