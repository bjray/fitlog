//
//  ActivityViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/5/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController
- (IBAction)recordSessionHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
