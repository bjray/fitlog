//
//  FLDataSource.h
//  fitlog
//
//  Created by B.J. Ray on 2/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLConstants.h"
@class RACSignal;

@protocol FLDataSource <NSObject>

//- (void)findObjectsInBackgroundWithBlock:(FLArrayResultBlock)block;
- (RACSignal *)fetchAllActivityTypes;
@end
