//
//  FLActivityListViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/8/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityListViewController.h"
#import "FLActivityItemCell.h"
#import "FLActivityManager.h"
#import "FLActivityType.h"
#import "MBProgressHUD.h"
#import <TSMessages/TSMessage.h>

@interface FLActivityListViewController ()
@property (nonatomic, retain) NSArray *activityTypes;
@end

@implementation FLActivityListViewController
{
    NSArray *_searchResults;
}

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
    
	self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayController.searchBar.barStyle = UIBarStyleBlackTranslucent;
    [TSMessage setDefaultViewController:self.navigationController];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    [[[FLActivityManager sharedManager] fetchAllActivityTypes] subscribeNext:^(NSArray *activityList) {
        self.activityTypes = activityList;
        
        [self.tableView reloadData];

        [hud hide:YES];
    } error:^(NSError *error) {
        NSLog(@"inner oh no!");
        [self displayError:error optionalMsg:nil];
        [hud hide:YES];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
    } else {
        return self.activityTypes.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLActivityType *activity;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        static NSString *CellIdentifier = @"SearchCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        activity = [_searchResults objectAtIndex:indexPath.row];
        
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:(252.0/255.0) green:77.0/255.0 blue:154.0/255.0 alpha:1.0];
        cell.textLabel.text = activity.name;
        return cell;
    } else {
        static NSString *CellIdentifier = @"ActivityCell";
        FLActivityItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        activity = [self.activityTypes objectAtIndex:indexPath.row];
        cell.activityLabel.text = activity.name;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		NSLog(@"clicking on search cell");
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //perform segue...
        [self performSegueWithIdentifier:@"ActivityDetailsFromListSegue" sender:cell];
    } else {
        NSLog(@"clicking on normal tablecell");
    }
}

#pragma mark - Search
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.showsCancelButton = YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.showsCancelButton = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    _searchResults = [self filterActivities:searchString];
    return YES;
}

- (NSArray *)filterActivities:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    return [self.activityTypes filteredArrayUsingPredicate:predicate];
}

#pragma mark - Helper methods...
- (void)displayError:(NSError *)error optionalMsg:(NSString *)optionalMsg{
    NSString *msg = [NSString stringWithFormat:@"%@ %@", [error localizedDescription], optionalMsg];
    
    [TSMessage showNotificationWithTitle:@"Error" subtitle:msg type:TSMessageNotificationTypeError];
}



#pragma mark - Navigation Code
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = [segue destinationViewController];
    
    if ([destination respondsToSelector:@selector(setActivityType:)]) {
        //have to pull from cell because this call could be coming from search tableview
        UITableViewCell *cell = (UITableViewCell *)sender;
        FLActivityType *selectedActivity = [[FLActivityManager sharedManager] findActivityTypeFromActivities:self.activityTypes
                                                                                                      byName:cell.textLabel.text];
        [destination setValue:selectedActivity forKey:@"activityType"];
    }
}
@end
