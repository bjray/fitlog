//
//  FLLoginViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/6/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLLoginViewController.h"
#import "AppDelegate.h"
#import "FLUserManager.h"


@interface FLLoginViewController ()
@property (nonatomic, strong) PFLogInViewController *logInViewController;
@end

@implementation FLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        // Push the next view controller without animation
        [self performSegueWithIdentifier:@"TabBarSegue" sender:self];
    } else {
        NSLog(@"not logged in or cached");
        self.logInViewController = [[PFLogInViewController alloc] init];
        self.logInViewController.fields = PFLogInFieldsTwitter | PFLogInFieldsFacebook;
        [self.logInViewController setDelegate:self];
        [self presentViewController:self.logInViewController animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFLogInViewControllerDelegate methods
- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    NSLog(@"did login user");
    [self.logInViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
