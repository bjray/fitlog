//
//  FLUser.h
//  fitlog
//
//  Created by B.J. Ray on 2/17/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLUser : PFObject <PFSubclassing>
+(NSString *)parseClassName;

@property (retain) NSString *username;
@property (nonatomic, retain, readonly) NSString *name;
@end
