//
//  FLLoginViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/6/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

- (IBAction)loginHandler:(id)sender;
- (IBAction)logoutHandler:(id)sender;


@end
