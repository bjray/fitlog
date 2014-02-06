//
//  Activity_Type.h
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity_Type : NSManagedObject

@property (nonatomic, retain) NSString * activity_type_id;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSNumber * is_active;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sm_owner;

@end
