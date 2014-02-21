//
//  FLActivitySelectionViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/13/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivitySelectionViewController.h"
#import "FLActivityItemCollectionCell.h"
#import "FLActivityManager.h"
#import "FLActivityType.h"
#import "MBProgressHUD.h"

@interface FLActivitySelectionViewController ()
@property (nonatomic, retain)NSArray *favoriteActivities;
@end

@implementation FLActivitySelectionViewController

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
    self.navigationItem.title = @"Log an Activity";
    self.favoriteActivities = [NSArray array];
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
    
    [[[FLActivityManager sharedManager] fetchFavoriteActivitiesForUser:[PFUser currentUser]] subscribeNext:^(NSArray *favs) {
        self.favoriteActivities = favs;
        
        [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        NSLog(@"inner oh no!");
//        [self displayError:error optionalMsg:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - User Actions
- (IBAction)recordSessionHandler:(id)sender {
    NSLog(@"Record a session...");
    //[self performSegueWithIdentifier:@"SessionSegue" sender:self];
}

#pragma mark – Navigation Code

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ActivityDetailsSegue"] ) {
        NSLog(@"handle ActivityDetailsSegue");
    } else if ([segue.identifier isEqualToString:@"ActivityFullListSegue"]) {
        NSLog(@"handle ActivityFullListSegue");
    }
    
}

#pragma mark - UICollectionView Datasource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    FLActivityItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityItemCell" forIndexPath:indexPath];
//    cell.layer.cornerRadius = 5;
//    cell.layer.masksToBounds = YES;
//    cell.layer.masksToBounds = NO;
//    cell.layer.shadowOpacity = 0.9f;
//    cell.layer.shadowRadius = 0.5;
//    cell.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    
    if (row == 7) {
        cell.activityLabel.text = @"view all";
    } else if (row >= self.favoriteActivities.count) {
        cell.activityLabel.text = @"+";
    } else {
        FLActivityType *activity = [self.favoriteActivities objectAtIndex:row];
        cell.activityLabel.text = activity.name;
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO: Temp code...
    if (indexPath.row == 7) {
        //go to activity full list...
        [self performSegueWithIdentifier:@"ActivityFullListSegue" sender:self];
    } else if (indexPath.row >= [FLActivityManager sharedManager].favoriteActivityTypes.count) {
        NSString *activity = @"new activity";
        NSLog(@"Selected activity: %@,  in row: %d", activity, indexPath.row);
        [self performSegueWithIdentifier:@"ActivityDetailsSegue" sender:self];
    } else {
        //go to activity details...
        NSString *activity = [[FLActivityManager sharedManager].favoriteActivityTypes objectAtIndex:indexPath.row];
        NSLog(@"Selected activity: %@,  in row: %d", activity, indexPath.row);
        [self performSegueWithIdentifier:@"ActivityDetailsSegue" sender:self];
    }
    
    
}


@end
