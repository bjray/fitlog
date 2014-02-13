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

@interface FLActivitySelectionViewController ()
@property (nonatomic, retain)NSArray *activities;   //Temp
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
	// Do any additional setup after loading the view.
    self.activities = @[@"Running",@"Boxing",@"Mini Murph",@"Sprint - ladders",@"Cycling",@"Hill Repeats",@"Abs", @"View All"];
    self.navigationItem.title = @"Log an Activity";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.activities.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FLActivityItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityItemCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 0.9f;
    
    cell.activityLabel.text = [self.activities objectAtIndex:indexPath.row];
    
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
        NSString *activity = [self.activities objectAtIndex:indexPath.row];
        NSLog(@"Selected activity: %@,  in row: %d", activity, indexPath.row);
        [self performSegueWithIdentifier:@"ActivityDetailsSegue" sender:self];
    }
    
    
}


@end
