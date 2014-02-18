//
//  FLUser.m
//  fitlog
//
//  Created by B.J. Ray on 2/17/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLUser.h"
#import <Parse/PFObject+Subclass.h>

@interface FLUser()
@property (nonatomic, retain, readwrite) NSString *name;
@end

@implementation FLUser
@dynamic username;
@synthesize name;

+ (NSString *)parseClassName {
    return @"User";
}

- (NSString *)user {
    return @"no name yet";
}

@end