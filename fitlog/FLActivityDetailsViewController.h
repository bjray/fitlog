//
//  FLActivityDetailsViewController.h
//  fitlog
//
//  Created by B.J. Ray on 2/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLActivityType;
@class FLActivity;

@interface FLActivityDetailsViewController : UITableViewController <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *completionDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (weak, nonatomic) IBOutlet UILabel *repeatsLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextField *repeatsTextField;
@property (nonatomic, strong) FLActivity *activity;

- (IBAction)completionDateChanged:(id)sender;
- (IBAction)saveHandler:(id)sender;
- (IBAction)displayActivityDescription:(id)sender;
- (IBAction)closeHandler:(id)sender;


@end
