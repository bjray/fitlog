//
//  FLActivity.m
//  fitlog
//
//  Created by B.J. Ray on 3/2/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivity.h"

@implementation FLActivity


- (id)init {
    return [self initWithActivityType:nil dateTime:[NSDate date]];
}

- (id)initWithActivityType:(FLActivityType *)activityType dateTime:(NSDate *)date {
    self = [super init];
    if (self) {
        if (activityType) {
            self.activityTypeId = activityType.objectId;
            self.name = activityType.name;
        } else {
            self.activityTypeId = nil;
            self.name = @"New Activity";
        }
        
        self.completionDate = date;
        self.comment = nil;
        self.duration = 0;
        self.repeats = 1;
    }
    return self;
}

- (NSString *)completionDateStr {
    return [self formatDate:self.completionDate];
}


- (NSString *)formatDate:(NSDate *)theDate
{
	static NSDateFormatter *formatter;
	if (formatter == nil) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
	}
    
	return [formatter stringFromDate:theDate];
}

- (NSString *)description {
    NSString *times = @"time";
//    NSString *duration = @"";
    
    if (self.repeats > 1) {
        times = @"times";
    }
    NSString *result = [NSString stringWithFormat:@"%@ performed %d %@ on %@.", self.name, self.repeats, times, [self formatDate:self.completionDate]];
    
    return result;
}
@end
