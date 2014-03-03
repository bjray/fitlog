//
//  FLActivity.h
//  fitlog
//
//  Created by B.J. Ray on 3/2/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLActivity : NSObject
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *activityTypeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *comment;
@property NSInteger count;
@property NSTimeInterval duration;
@property (nonatomic, retain) NSDate *completionDate;
@property (nonatomic, retain) NSString *completionDateStr;
@property (nonatomic, retain) CLLocation *location;
@end
