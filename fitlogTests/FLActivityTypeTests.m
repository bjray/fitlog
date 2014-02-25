//
//  FLActivityTypeTests.m
//  fitlog
//
//  Created by B.J. Ray on 2/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FLActivityType.h"


@interface FLActivityTypeTests : XCTestCase
@property FLActivityType *activity1;
@property FLActivityType *activity2;
@end

@implementation FLActivityTypeTests

- (void)setUp
{
    [super setUp];
    self.activity1 = [[FLActivityType alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatObjectExists {
    FLActivityType *anActivity = [[FLActivityType alloc] init];
    XCTAssertNotNil(anActivity, @"should be able to create an Activity object");
}

- (void)testThatActivityClassNameIsCorrect {
    XCTAssertEqualObjects(@"One", @"One", @"These strings should be equal");
    
}

//- (void)testThatTwoActivitiesAreEqual {
//    
//}
//
//- (void)testThatTwoActivitiesAreNotEqual {
//    
//}

@end
