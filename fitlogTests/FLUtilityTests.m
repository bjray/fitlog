//
//  FLUtilityTests.m
//  fitlog
//
//  Created by B.J. Ray on 3/3/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FLUtility.h"

@interface FLUtilityTests : XCTestCase
@property (nonatomic, retain) FLUtility *fu;
@end

@implementation FLUtilityTests

- (void)setUp
{
    [super setUp];
    self.fu = [FLUtility sharedManager];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.fu = nil;
}


- (void)testHoursToTimeInterval {
    NSInteger hours = 5;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:hours minutes:0 seconds:0];
    XCTAssert(interval == 5*3600, @"failed to convert hours to time interval");
    
}

- (void)testMinutesToTimeInterval {
    NSInteger minutes = 5;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:0 minutes:minutes seconds:0];
    XCTAssert(interval == 5*60, @"failed to convert minutes to time interval");
}

- (void)testSecondsToTimeInterval {
    NSInteger seconds = 5;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:0 minutes:0 seconds:seconds];
    XCTAssert(interval == 5, @"failed to convert seconds to time interval");
}

- (void)testMinutesGreaterThan60ToHoursAndMinutes {
    NSInteger minutes = 65;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:0 minutes:minutes seconds:0];
    XCTAssert(interval == 65*60, @"failed to convert minutes to time interval");
}

- (void)testSecondsGreaterThan60ToMinutesAndSeconds {
    NSInteger seconds = 65;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:0 minutes:0 seconds:seconds];
    XCTAssert(interval == 65, @"failed to convert minutes to time interval");
}

- (void)testHoursMinutesSecondsToTimeInterval {
    NSInteger seconds = 65;
    NSInteger minutes = 5;
    NSInteger hours = 1;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:hours minutes:minutes seconds:seconds];
    XCTAssert(interval == (1*3600+5*60+65), @"failed to convert minutes to time interval");
}

- (void)testHoursAndMinutesToTimeInterval {
    NSInteger hours = 2;
    NSInteger minutes = 55;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:hours minutes:minutes seconds:0];
    XCTAssert(interval == (2*3600 + 55*60), @"failed to convert minutes to time interval");
    
    minutes = 65;
    interval = [FLUtility timeIntervalFromHours:hours minutes:minutes seconds:0];
    XCTAssert(interval == (2*3600 + 65*60), @"failed to convert minutes to time interval");
}

- (void)testHoursAndMinutesOver60ToTimeInterval {
    NSInteger hours = 2;
    NSInteger minutes = 65;
    NSTimeInterval interval = [FLUtility timeIntervalFromHours:hours minutes:minutes seconds:0];
    XCTAssert(interval == (2*3600 + 65*60), @"failed to convert minutes to time interval");
}

//stringFromTimeInterval
- (void)test55SecondsToFormattedString {
    NSTimeInterval time = 55.0;
    NSString *result = [FLUtility stringFromTimeInterval:time withBaseInterval:0.0];
    XCTAssertNotNil(result, @"Should get a value back.");
    XCTAssertEqualObjects(result, @"00:55:00", @"failed to format time interval correctly");
}

- (void)test65SecondsToFormattedString {
    NSTimeInterval time = 65.0;
    NSString *result = [FLUtility stringFromTimeInterval:time withBaseInterval:0.0];
    XCTAssertEqualObjects(result, @"01:05:00", @"failed to format time interval correctly");
}

- (void)test1Hour65Minutes65SecondsToFormattedString {
    NSTimeInterval time = 1*3600+65*60+65;
    NSString *result = [FLUtility stringFromTimeInterval:time withBaseInterval:0.0];
    XCTAssertEqualObjects(result, @"02:06:05:00", @"failed to format time interval correctly");
}

- (void)test72HoursToFormattedString {
    NSTimeInterval time = 72*3600;
    NSString *result = [FLUtility stringFromTimeInterval:time withBaseInterval:0.0];
    XCTAssertEqualObjects(result, @"72:00:00:00", @"failed to format time interval correctly");
}

- (void)test55SecondsAndBase5Minutes10SecondsToFormattedString {
    NSTimeInterval time = 55;
    NSTimeInterval base = 5*60+10;
    NSString *result = [FLUtility stringFromTimeInterval:time withBaseInterval:base];
    XCTAssertEqualObjects(result, @"06:05:00", @"failed to format time interval correctly");
}
@end
