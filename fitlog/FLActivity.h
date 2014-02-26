//
//  FLActivity.h
//  fitlog
//
//  Created by B.J. Ray on 2/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLActivity : NSObject
//- (id)initWithActivityType:(FLActivityType *)activityType user:(PFUser *)user dateTime:(NSDate *)date;

@property (nonatomic, copy) NSString *comment;
@property NSInteger count;
@property NSTimeInterval time;
@property (nonatomic, retain) CLLocation *location;
@end
