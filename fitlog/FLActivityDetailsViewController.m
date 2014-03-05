//
//  FLActivityDetailsViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityDetailsViewController.h"
#import "FLActivity.h"
#import "FLActivityManager.h"
#import "FLUtility.h"
#import "MBProgressHUD.h"
#import <TSMessages/TSMessage.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>


#define DESCRIPTION_ROW 1
#define REPEATS_ROW 2
#define COMPLETION_ROW 4
#define DURATION_ROW 6
#define COMMENT_ROW 9
#define ANIMATION_DURATION 0.25f

@interface FLActivityDetailsViewController ()
@property (nonatomic, retain)NSArray *secondsArray;
@end

@implementation FLActivityDetailsViewController
{
    NSInteger _hour;
    NSInteger _minute;
    NSInteger _second;
}
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
    self.completionDatePicker.hidden = YES;
    self.durationPicker.hidden = YES;
    self.descriptionLabel.hidden = YES;
    _hour = [FLUtility hoursFromTimeInterval:self.activity.duration];
    _minute = [FLUtility cappedMinutesFromTimeInterval:self.activity.duration];
    _second = [FLUtility cappedSecondsFromTimeInterval:self.activity.duration];
    
    self.secondsArray = @[@"0",@"15",@"30",@"45"];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
    [TSMessage setDefaultViewController:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameLabel.text = self.activity.name;
//    self.durationLabel.text = @"00:00:00";
    self.durationLabel.text = [FLUtility stringFromTimeInterval:self.activity.duration];
    self.completionDateLabel.text = self.activity.completionDateStr;
    self.repeatsLabel.text = [NSString stringWithFormat:@"%d", self.activity.repeats];
    self.repeatsTextField.text = [NSString stringWithFormat:@"%d", self.activity.repeats];
    self.commentTextView.text = self.activity.comment;
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DESCRIPTION_ROW) {
        return self.descriptionLabel.hidden ? 0.0f : 132.0f;
    } else if (indexPath.row == COMPLETION_ROW) {
        return self.completionDatePicker.hidden ? 0.0f : 217.0f;
    } else if (indexPath.row == DURATION_ROW) {
        return self.durationPicker.hidden ? 0.0f : 217.0f;
    } else if (indexPath.row == COMMENT_ROW) {
        return 140.0f;
    } else {
        return 44.0f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DESCRIPTION_ROW-1) {
        if (self.descriptionLabel.hidden) {
            [self showDescription];
            [self hidePicker:self.completionDatePicker withLabel:self.completionDateLabel];
            [self hidePicker:self.durationPicker withLabel:self.durationLabel];
        } else {
            [self hideDescription];
        }
    } else if (indexPath.row == REPEATS_ROW) {
        if (self.repeatsTextField.hidden) {
            [self showRepeatsTextField];
        } else {
            [self hideRepeatsTextField];
        }
    } else if (indexPath.row == COMPLETION_ROW-1) {

        if (self.completionDatePicker.hidden) {
            [self showPicker:self.completionDatePicker withLabel:self.completionDateLabel];
            [self hidePicker:self.durationPicker withLabel:self.durationLabel];
            [self hideDescription];
        } else {
            [self hidePicker:self.completionDatePicker withLabel:self.completionDateLabel];
        }
    } else if (indexPath.row == DURATION_ROW-1) {
        if (self.durationPicker.hidden) {
            [self showPicker:self.durationPicker withLabel:self.durationLabel];
            [self hidePicker:self.completionDatePicker withLabel:self.completionDateLabel];
        } else {
            [self hidePicker:self.durationPicker withLabel:self.durationLabel];
        }
    } else {
        [self hideDescription];
        [self hidePicker:self.durationPicker withLabel:self.durationLabel];
        [self hidePicker:self.completionDatePicker withLabel:self.completionDateLabel];
        [self hideRepeatsTextField];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Picker DataSource Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1 || component == 3 || component == 5) {
        return 1;
    } else if (component == 4) {
        return [self.secondsArray count];
    } else {
        return 60;
    }
}

#pragma mark - Picker Delegate Methods
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *title = @"";
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    }
    
    switch (component) {
        case 0:
            title = [[NSNumber numberWithInt:row] stringValue];
            label.textAlignment = NSTextAlignmentRight;
            break;
        case 1:
            title = @"hr";
            label.textAlignment = NSTextAlignmentLeft;
            break;
        case 2:
            title = [[NSNumber numberWithInt:row] stringValue];
            label.textAlignment = NSTextAlignmentRight;
            break;
        case 3:
            title = @"min";
            label.textAlignment = NSTextAlignmentLeft;
            break;
        case 4:
            title = [self.secondsArray objectAtIndex:row];
            label.textAlignment = NSTextAlignmentRight;
            break;
        case 5:
            title = @"sec";
            label.textAlignment = NSTextAlignmentLeft;
            break;
        default:
            break;
    }
    label.text = title;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"picker row selected");
    
    if (component == 0) {
        _hour = row;
    } else if (component == 2) {
        _minute = row;
    } else if (component == 4) {
        _second = [[_secondsArray objectAtIndex:row] integerValue];
    }
    self.activity.duration = [FLUtility timeIntervalFromHours:_hour minutes:_minute seconds:_second];
    
    self.durationLabel.text = [FLUtility stringFromTimeInterval:self.activity.duration];
//    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", _hour, _minute, _second];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 35.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

#pragma mark - TextField Delegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *value = textField.text;
    if (value.length == 0) {
        value = @"1";
    }
    self.repeatsLabel.text = value;
    self.activity.repeats = [value integerValue];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - TextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self hideDescription];
    [self hidePicker:self.completionDatePicker withLabel:self.completionDateLabel];
    [self hidePicker:self.durationPicker withLabel:self.durationLabel];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
//    [self animateTextField:textView up:NO];
    self.activity.comment = textView.text;
    [textView resignFirstResponder];
}


#pragma mark - AlertView Delegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self closeHandler:nil];
}


#pragma mark - Helper Methods
- (void)hideKeyboard
{
	// This trick dismissed the keyboard, no matter which text field or text
	// view is currently active.
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)showPicker:(UIView *)picker withLabel:(UILabel *)label {
//    NSIndexPath *pickerCellPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    label.textColor = self.tableView.tintColor;
    picker.hidden = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    picker.alpha = 0.0f;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        picker.alpha = 1.0f;
    }];
    
}

- (void)hidePicker:(UIView *)picker withLabel:(UILabel *)label {

    label.textColor = [UIColor blackColor];
    
    if (!picker.hidden) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            picker.alpha = 1.0f;
        } completion:^(BOOL finished) {
            picker.hidden = YES;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }];
    }
}

- (void)showDescription {
    self.descriptionLabel.hidden = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.descriptionLabel.alpha = 0.0;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.descriptionLabel.alpha = 1.0f;
    }];
}

- (void)hideDescription {
    if (!self.descriptionLabel.hidden) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.descriptionLabel.alpha = 1.0f;
        } completion:^(BOOL finished) {
            self.descriptionLabel.hidden = YES;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }];
    }
}

- (void)showRepeatsTextField {
    self.repeatsTextField.hidden = NO;
    self.repeatsLabel.hidden = YES;
    self.repeatsTextField.alpha = 0.0;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.repeatsTextField.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.repeatsTextField becomeFirstResponder];
//        self.repeatsTextField.becomeFirstResponder = YES;
    }];
}

- (void)hideRepeatsTextField {
    if (!self.repeatsTextField.hidden) {
        self.repeatsTextField.hidden = YES;
        self.repeatsLabel.hidden = NO;
        self.repeatsLabel.alpha = 0.0;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.repeatsLabel.alpha = 1.0f;
        }];
    }
}

- (NSString *)formatDate:(NSDate *)theDate
{
	static NSDateFormatter *formatter;
	if (formatter == nil) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
	}
    
	return [formatter stringFromDate:theDate];
}

//- (NSString *) formatTime:(NSDate *)theDate {
//    static NSDateFormatter *formatter;
//	if (formatter == nil) {
//		formatter = [[NSDateFormatter alloc] init];
//		[formatter setDateFormat:@"HH:mm"];
//	}
//	return [formatter stringFromDate:theDate];
//}

#pragma mark - User Actions
- (IBAction)completionDateChanged:(id)sender {
    self.completionDateLabel.text = [self formatDate:self.completionDatePicker.date];
}

- (IBAction)saveHandler:(id)sender {
    [self hideDescription];
    [self hidePicker:self.completionDatePicker withLabel:self.completionDateLabel];
    [self hidePicker:self.durationPicker withLabel:self.durationLabel];
    [self hideKeyboard];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Saving...";
    
    [[[FLActivityManager sharedManager] saveActivity:self.activity forUser:[PFUser currentUser]] subscribeError:^(NSError *error) {
        [TSMessage showNotificationWithTitle:@"Error" subtitle:@"Failed to save activity." type:TSMessageNotificationTypeError];
        [hud hide:YES];
    } completed:^{
        [hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Successful"
                                                        message:@"You just made another step forward!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
//        [TSMessage showNotificationWithTitle:@"Save" subtitle:@"Way to go!" type:TSMessageNotificationTypeSuccess];
//        [TSMessage showNotificationInViewController:self.navigationController
//                                              title:@"Save"
//                                           subtitle:@"Way to go!"
//                                               type:TSMessageNotificationTypeSuccess
//                                           duration:1.5
//                                           callback:^{
//                                               NSLog(@"callback executed...");
//                                               [self.navigationController popViewControllerAnimated:YES];
//                                           } buttonTitle:nil
//                                     buttonCallback:nil
//                                         atPosition:TSMessageNotificationPositionTop
//                                canBeDismisedByUser:YES];
    }];
}

- (IBAction)displayActivityDescription:(id)sender {
    if (self.descriptionLabel.hidden) {
        [self showDescription];
        [self hidePicker:self.completionDatePicker withLabel:self.completionDateLabel];
        [self hidePicker:self.durationPicker withLabel:self.durationLabel];
    } else {
        [self hideDescription];
    }
}

- (IBAction)closeHandler:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
