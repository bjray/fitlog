//
//  FLActivityType.h
//  fitlog
//
//  Created by B.J. Ray on 2/17/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLActivityType : PFObject <PFSubclassing>
+(NSString *)parseClassName;

@property (retain) NSString *name;
//@property (retain) NSString *objectId;
- (BOOL)isEqualToActivity:(FLActivityType *)activity;

@end

