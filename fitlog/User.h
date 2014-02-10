//
//  User.h
//  fitlog
//
//  Created by B.J. Ray on 2/10/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StackMob.h"

@class Activity_Type;

@interface User : SMUserManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * sm_owner;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSSet *favorites;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFavoritesObject:(Activity_Type *)value;
- (void)removeFavoritesObject:(Activity_Type *)value;
- (void)addFavorites:(NSSet *)values;
- (void)removeFavorites:(NSSet *)values;

@end
