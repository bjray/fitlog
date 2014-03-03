//
//  FLActivity.h
//  fitlog
//
//  Created by B.J. Ray on 3/2/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLActivityType.h"

@interface FLActivity : NSObject
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *activityTypeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *comment;
@property NSInteger repeats;
@property NSTimeInterval duration;
@property (nonatomic, retain) NSDate *completionDate;
@property (nonatomic, retain, readonly) NSString *completionDateStr;
@property (nonatomic, retain) CLLocation *location;


- (id)initWithActivityType:(FLActivityType *)activityType dateTime:(NSDate *)date;
@end
