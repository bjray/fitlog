//
//  FLLoginViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/6/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLLoginDelegate.h"

@interface FLLoginViewController : UIViewController <FLLoginDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) id<FLLoginDelegate> delegate;

- (IBAction)loginHandler:(id)sender;
- (IBAction)logoutHandler:(id)sender;


@end
