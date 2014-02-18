//
//  FLActivityType.m
//  fitlog
//
//  Created by B.J. Ray on 2/17/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityType.h"
#import <Parse/PFObject+Subclass.h>

@implementation FLActivityType
@dynamic name;
//@dynamic objectId;

+ (NSString *)parseClassName {
    return @"ActivityType";
}

@end
