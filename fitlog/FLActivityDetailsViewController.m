//
//  FLActivityDetailsViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLActivityDetailsViewController.h"
#import <TSMessages/TSMessage.h>

@interface FLActivityDetailsViewController ()

@end

@implementation FLActivityDetailsViewController

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
    self.commentsView.layer.cornerRadius = 8;
    self.commentsView.layer.masksToBounds = NO;
    self.commentsView.layer.shadowOpacity = 0.9f;
    self.commentsView.layer.shadowRadius = 1;
    self.commentsView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    
	// Do any additional setup after loading the view.
    [TSMessage setDefaultViewController:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveHandler:(id)sender {
    NSLog(@"you did it!");
    [TSMessage showNotificationWithTitle:@"Error" subtitle:@"Save is not hooked up yet." type:TSMessageNotificationTypeError];
    
}

- (IBAction)backgroundTap:(id)sender {
    [self.activityCommentsTextView resignFirstResponder];
    NSLog(@"background tap");
}

#pragma mark - TextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self animateTextField:textView up:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self animateTextField:textView up:NO];
}


#pragma mark - Helper Methods
- (void)animateTextField:(UITextView *)textField up:(BOOL)up
{
    const int movementDistance = 85;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
