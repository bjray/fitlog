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
    
    //TODO: Replace with ReactiveCocoa
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSyncDidFinishNotification:) name:@"FinishedSync" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFetchDidFinishNotification:) name:@"FinishedFetch" object:nil];
    
    //TODO: Here for now because this class isn't intantiated when the notification is fired...
    [self fetchData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - These methods are temporary
//Used until I introduce signals...

- (void)fetchData {
    [[FLActivityManager sharedManager] getAllActivityTypes];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}

//TODO: This needs to be removed and we need to use Signals instead
- (void)didReceiveSyncDidFinishNotification:(NSNotification *)notification {
    NSLog(@"Sync Finished notification received");
    [self fetchData];
}
//TODO: Remove this as well...
- (void)didReceiveFetchDidFinishNotification:(NSNotification *)notification {
    NSLog(@"Fetch Finished notification received");
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - TableView methods...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[FLActivityManager sharedManager] itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ActivityTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[FLActivityManager sharedManager] nameAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
