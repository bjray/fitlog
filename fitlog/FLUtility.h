//
//  FLUtility.h
//  fitlog
//
//  Created by B.J. Ray on 3/3/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUtility : NSObject
+(instancetype)sharedManager;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval withBaseInterval:(NSTimeInterval)baseInterval;
+ (NSTimeInterval)timeIntervalFromHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
+ (NSInteger)hoursFromTimeInterval:(NSTimeInterval)interval;
+ (NSInteger)cappedMinutesFromTimeInterval:(NSTimeInterval)interval;
+ (NSInteger)cappedSecondsFromTimeInterval:(NSTimeInterval)interval;
@end
