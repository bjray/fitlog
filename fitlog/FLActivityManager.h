//
//  FLActivityManager.h
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
@class FLActivityType;
@class FLActivity;

#define FL_FAVORITE @"Favorite"
#define FL_FAV_RELATION @"likes"

@interface FLActivityManager : NSObject
//@property (nonatomic, strong, readonly) NSArray *activityTypes;
//@property (nonatomic, strong, readonly) NSArray *favoriteActivityTypes;

+(instancetype)sharedManager;

- (BOOL)isFavoriteActivity:(FLActivityType *)activity within:(NSArray *)favorites;
- (FLActivityType *)findActivityTypeFromActivities:(NSArray *)activities byName:(NSString *)name;

- (RACSignal *)fetchAllActivityTypes;
- (RACSignal *)fetchFavoriteActivitiesForUser:(PFUser *)user;


- (RACSignal *)saveFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user;
- (RACSignal *)removeFavoriteActivity:(FLActivityType *)activity forUser:(PFUser *)user;
- (RACSignal *)saveActivity:(FLActivity *)activity forUser:(PFUser *)user;
@end
