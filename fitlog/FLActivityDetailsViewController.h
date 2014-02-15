//
//  FLActivityDetailsViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLActivityDetailsViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityCompletionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionDurationLabel;
@property (weak, nonatomic) IBOutlet UITextView *activityCommentsTextView;
@property (weak, nonatomic) IBOutlet UIView *commentsView;


- (IBAction)saveHandler:(id)sender;
- (IBAction)backgroundTap:(id)sender;


@end
