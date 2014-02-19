//
//  FavoriteActivityViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FavoriteActivityViewController.h"
#import "MBProgressHUD.h"
#import "FLActivityManager.h"
#import <TSMessages/TSMessage.h>

@interface FavoriteActivityViewController ()

@end

@implementation FavoriteActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Favorites";
    
    //observe changes to activityTypes collection...
    [[RACObserve([FLActivityManager sharedManager], activityTypes)
     deliverOn:RACScheduler.mainThreadScheduler]
    subscribeNext:^(NSNumber *newItemCount) {
        NSLog(@"observed a signal!!!");
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    [[RACObserve([FLActivityManager sharedManager], favoriteActivityTypes)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newFavs) {
         NSLog(@"observed new fav signals!!!");
         [self.tableView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    [TSMessage setDefaultViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Here for now because this class isn't intantiated when the notification is fired...
    [self fetchData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //TODO:
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    [[FLActivityManager sharedManager] fetchAllActivityTypes];
    [[FLActivityManager sharedManager] fetchFavoriteActivitiesForUser:[PFUser currentUser]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}

#pragma mark - TableView methods...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FLActivityManager sharedManager] itemCount].integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ActivityTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[FLActivityManager sharedManager] nameAtIndexPath:indexPath];
    if ([[FLActivityManager sharedManager] isFavoriteAtIndexPath:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        //make save request...
        
//        [[[FLActivityManager sharedManager]saveFavoriteActivityAtIndex:indexPath.row forUser:[PFUser currentUser]] subscribeError:^(NSError *error) {
//            [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching the latest favorites." type:TSMessageNotificationTypeError];
//        }];
        
        [[[FLActivityManager sharedManager]saveFavoriteActivityAtIndex:indexPath.row forUser:[PFUser currentUser]] subscribeError:^(NSError *error) {
            [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching the latest favorites." type:TSMessageNotificationTypeError];
        } completed:^{
            [TSMessage showNotificationWithTitle:@"Yeah!" subtitle:@"How do you like them apples?" type:TSMessageNotificationTypeSuccess];
        }];

//        RACSignal *signal = [[FLActivityManager sharedManager]saveFavoriteActivityAtIndex:indexPath.row forUser:[PFUser currentUser]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        //make remove request...
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
}

@end
