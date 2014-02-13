//
//  FLSessionViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/13/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLSessionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *pausePlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

- (IBAction)togglePausePlayHandler:(id)sender;

- (IBAction)saveHandler:(id)sender;
- (IBAction)resetHandler:(id)sender;
@end
