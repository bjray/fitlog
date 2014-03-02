//
//  FLActivityDetailsViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLActivityType;

@interface FLActivityDetailsViewController : UITableViewController <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *completionDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) FLActivityType *activityType;

- (IBAction)completionDateChanged:(id)sender;

@end
