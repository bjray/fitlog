//
//  FLUtility.m
//  fitlog
//
//  Created by B.J. Ray on 3/3/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLUtility.h"

@implementation FLUtility

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
        //perform any necessary set up here...
    }
    return self;
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    return [self stringFromTimeInterval:interval withBaseInterval:0.0];
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval withBaseInterval:(NSTimeInterval)baseInterval {
    NSString *result = @"";
    double ti = interval + baseInterval;
    
    NSInteger millisecond = [self cappedMilliSecondsFromTimeInterval:ti];
    NSInteger seconds = [self cappedSecondsFromTimeInterval:ti];
    NSInteger minutes = [self cappedMinutesFromTimeInterval:ti];
    NSInteger hours = [self hoursFromTimeInterval:ti];
    
    if (hours > 0) {
        result = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i", hours, minutes, seconds, millisecond];
    } else {
        result = [NSString stringWithFormat:@"%02i:%02i:%02i", minutes, seconds, millisecond];
    }
    return result;
}

+ (NSTimeInterval)timeIntervalFromHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    NSTimeInterval interval = 0.0;
    interval = hours * 60 * 60 + minutes * 60 + seconds;
    return interval;
}


+ (NSInteger)hoursFromTimeInterval:(NSTimeInterval)interval {
    return ((NSInteger)(interval)/3600);
}

+ (NSInteger)cappedMinutesFromTimeInterval:(NSTimeInterval)interval {
    return ((NSInteger)(interval)/60)%60;
}

+ (NSInteger)cappedSecondsFromTimeInterval:(NSTimeInterval)interval {
    return (NSInteger)fmod((interval), 60);
}

+ (NSInteger)cappedMilliSecondsFromTimeInterval:(NSTimeInterval)interval {
    return (NSInteger)(fmod((interval), 1) * 100);
}

@end
