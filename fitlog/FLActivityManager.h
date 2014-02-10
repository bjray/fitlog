//
//  FLActivityManager.h
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FLActivityManager : NSObject

+(instancetype)sharedManager;

- (NSString *)nameAtIndexPath:(NSIndexPath *) indexPath;
- (NSString *)idAtIndexPath:(NSIndexPath *) indexPath;
- (NSInteger)itemCount;

- (void)getAllActivityTypes;
- (void)commitTransactions;
- (void)tableViewCell:(UITableViewCell *)cell toggleFavoriteAtIndexPath:(NSIndexPath *)indexPath;
@end
