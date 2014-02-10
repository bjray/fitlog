//
//  FLLoginViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/6/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLLoginViewController.h"
#import "StackMob.h"
#import "AppDelegate.h"
#import "FLUserManager.h"
#import "User.h"

@interface FLLoginViewController ()

@end

@implementation FLLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Interaction
- (IBAction)loginHandler:(id)sender {
    if ([[self appDelegate].client isLoggedIn]) {
        NSLog(@"We shouldn't be calling this because this button should be visible...");
    } else {
        [[FLUserManager sharedManager] openFacebookSession];
    }
    
    [self updateUI];
}

- (IBAction)logoutHandler:(id)sender {
    NSLog(@"logout!");
    [[FLUserManager sharedManager] logoutUser];
    [self updateUIAsUnknown];
}

#pragma mark - Helper methods...

- (void)updateUI {
    if ([[self appDelegate].client isLoggedIn]) {
        [self updateUIAsAuthenticated];
    } else {
        [self updateUIAsUnknown];
    }
}
- (void)updateUIAsAuthenticated {
    User *user = [FLUserManager sharedManager].user;
    if (user.username.length > 0) {
        self.welcomeLabel.text = [NSString stringWithFormat:@"Wecome back, %@.", user.username];
    } else {
        self.welcomeLabel.text = @"Welcome back.";
    }
    
    self.logoutBtn.hidden = NO;
    self.loginBtn.hidden = YES;
}

- (void)updateUIAsUnknown {
    self.welcomeLabel.text = @"Welcome to fitlog";
    self.logoutBtn.hidden = YES;
    self.loginBtn.hidden = NO;
}



@end
