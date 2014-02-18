//
//  FLActivityManager.h
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>


@interface FLActivityManager : NSObject
@property (nonatomic, strong, readonly) NSArray *activityTypes;
@property (nonatomic, strong, readonly) NSArray *favoriteActivitiesTypes;

+(instancetype)sharedManager;

- (NSString *)nameAtIndexPath:(NSIndexPath *) indexPath;
- (NSString *)idAtIndexPath:(NSIndexPath *) indexPath;
- (NSNumber *)itemCount;

- (void)fetchAllActivityTypes;
- (void)fetchFavoriteActivities;
//- (RACSignal *)saveFavorite:(Activity_Type *)activity;

//- (RACSignal *)fetchAllActivityTypes;
- (void)tableViewCell:(UITableViewCell *)cell toggleFavoriteAtIndexPath:(NSIndexPath *)indexPath;
@end
