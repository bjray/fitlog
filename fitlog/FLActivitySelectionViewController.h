//
//  FLActivitySelectionViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/13/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface FLActivitySelectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (IBAction)recordSessionHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
