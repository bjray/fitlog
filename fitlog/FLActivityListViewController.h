//
//  FLActivityListViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/8/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//
// This VC handles displaying of the individual activity items in the list

#import <UIKit/UIKit.h>

@interface FLActivityListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
