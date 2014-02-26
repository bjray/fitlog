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
#import "FLActivityType.h"
#import <TSMessages/TSMessage.h>

@interface FavoriteActivityViewController ()
@property (nonatomic, retain) NSMutableArray *myActivities;
@property (nonatomic, retain) NSArray *activities;
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
    self.myActivities = [NSMutableArray array];
    self.activities = [NSArray array];
    
    [TSMessage setDefaultViewController:self.navigationController];
    [self fetchData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    [[[FLActivityManager sharedManager] fetchAllActivityTypes] subscribeNext:^(NSArray *newActivities) {
        NSLog(@"from fetch: %d", [newActivities count]);
        self.activities = newActivities;
        
        [[[FLActivityManager sharedManager] fetchFavoriteActivitiesForUser:[PFUser currentUser]] subscribeNext:^(NSMutableArray *favs) {
            self.myActivities = favs;
            
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } error:^(NSError *error) {
            NSLog(@"inner oh no!");
            [self displayError:error optionalMsg:nil];
            [hud hide:YES];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        
    } error:^(NSError *error) {
        NSLog(@"outer oh no!");
        [self displayError:error optionalMsg:nil];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [hud hide:YES];
    }];
}

#pragma mark - TableView methods...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ActivityTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    FLActivityType *activity = [self.activities objectAtIndex:indexPath.row];
    cell.textLabel.text = activity.name;
    
    if ([[FLActivityManager sharedManager]isFavoriteActivity:activity within:self.myActivities]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FLActivityType *activityType = [self.activities objectAtIndex:indexPath.row];
    
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        [self saveFavoriteActivityType:activityType forCell:cell];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self removeFavoriteActivityType:activityType forCell:cell];
    }
}

#pragma mark - Helpers
- (void)saveFavoriteActivityType:(FLActivityType *)activityType forCell:(UITableViewCell *)cell {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Saving...";
    
    [[[FLActivityManager sharedManager] saveFavoriteActivity:activityType forUser:[PFUser currentUser]] subscribeError:^(NSError *error) {
        [self displayError:error optionalMsg:@"Failed to save favorite."];
    } completed:^{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [hud hide:YES];
    }];
}

- (void)removeFavoriteActivityType:(FLActivityType *)activityType forCell:(UITableViewCell *)cell {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Removing...";
    
    [[[FLActivityManager sharedManager] removeFavoriteActivity:activityType forUser:[PFUser currentUser]]
     subscribeError:^(NSError *error) {
         [self displayError:error optionalMsg:@"Failed to remove favorite."];
     } completed:^{
         cell.accessoryType = UITableViewCellAccessoryNone;
         [hud hide:YES];
     }];
}


- (void)displayError:(NSError *)error optionalMsg:(NSString *)optionalMsg{
    NSString *msg = [NSString stringWithFormat:@"%@ %@", [error localizedDescription], optionalMsg];
    
    [TSMessage showNotificationWithTitle:@"Error" subtitle:msg type:TSMessageNotificationTypeError];
}

@end
