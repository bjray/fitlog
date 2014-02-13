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
#import "MBProgressHUD.h"

@interface FLActivitySelectionViewController ()
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
    
    
    //observe changes to activityTypes collection...
    [[RACObserve([FLActivityManager sharedManager], favoriteActivitiesTypes)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSNumber *newItemCount) {
         NSLog(@"observed favoriteActivitiesTypes signal!!!");
         [self.collectionView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
     }];
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    [[FLActivityManager sharedManager] fetchAllActivityTypes];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
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
//    return [FLActivityManager sharedManager].favoriteActivitiesTypes.count;
    return 8;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger activityCount = [FLActivityManager sharedManager].favoriteActivitiesTypes.count;
    NSInteger row = indexPath.row;
    
    FLActivityItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityItemCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 0.9f;
    
    if (row == 7) {
        cell.activityLabel.text = @"view all";
    } else if (row >= activityCount) {
        cell.activityLabel.text = @"+";
    } else {
        cell.activityLabel.text = [[FLActivityManager sharedManager].favoriteActivitiesTypes objectAtIndex:row];
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO: Temp code...
    if (indexPath.row == 7) {
        //go to activity full list...
        [self performSegueWithIdentifier:@"ActivityFullListSegue" sender:self];
    } else {
        //go to activity details...
        NSString *activity = [[FLActivityManager sharedManager].favoriteActivitiesTypes objectAtIndex:indexPath.row];
        NSLog(@"Selected activity: %@,  in row: %d", activity, indexPath.row);
        [self performSegueWithIdentifier:@"ActivityDetailsSegue" sender:self];
    }
    
    
}


@end
