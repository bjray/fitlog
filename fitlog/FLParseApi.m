//
//  FLParseApi.m
//  fitlog
//
//  Created by B.J. Ray on 2/26/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLParseApi.h"


@implementation FLParseApi

- (RACSignal *)fetchAllActivityTypes {
    PFQuery *query = [PFQuery queryWithClassName:@"ActivityType"];
    [query whereKey:@"isActive" equalTo:@YES];
    [self cachePolicyForQuery:query];
    
    return [self fetchDataForQuery:query];
}

#pragma mark - Helper methods

- (RACSignal *)fetchDataForQuery:(PFQuery *)query {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"retrieved %d objects", [objects count]);
                [subscriber sendNext:objects];
            } else {
                NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"No clean up here.");
        }];
    }];
}


- (PFQuery *)queryForAllActivities {
    PFQuery *query = [PFQuery queryWithClassName:@"ActivityType"];
    [query whereKey:@"isActive" equalTo:@YES];
    [self cachePolicyForQuery:query];
    return query;
}

- (void)cachePolicyForQuery:(PFQuery *)aQuery {
    aQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    aQuery.maxCacheAge = 60 * 60 * 24; //one day
}
@end
