//
//  FLSessionViewController.m
//  fitlog
//
//  Created by B.J. Ray on 2/13/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "FLSessionViewController.h"
#import "FLUtility.h"

@interface FLSessionViewController ()
@property (nonatomic, retain) NSTimer *sessionTimer;
@property (nonatomic, retain) NSDateFormatter *timerFormatter;
@property BOOL isTimerActive;
@property NSTimeInterval sessionInterval;
@property NSTimeInterval currentInterval;
@property (nonatomic, retain) NSDate *sessionDate;
@end

@implementation FLSessionViewController

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
    
    self.timerFormatter = [[NSDateFormatter alloc] init];
    [self.timerFormatter setDateFormat:@"HH : mm : ss.S"];

    [self resetTimer];
	
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isTimerActive) {
        [self stopTimer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)togglePausePlayHandler:(id)sender {
    if (self.isTimerActive) {
        [self stopTimer];
        [self.pausePlayBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        [self startTimer];
        [self.pausePlayBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (IBAction)saveHandler:(id)sender {
    NSLog(@"go to activity selection view...");
    [self stopTimer];
}

- (IBAction)resetHandler:(id)sender {
    NSLog(@"reset timer...");
    [self resetTimer];
    [self.pausePlayBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

- (void)stopTimer {
    //save the current elapsedTime...
    self.sessionInterval += self.currentInterval;

    //clear out the date so when we start timer, it starts from 0...
    self.sessionDate = nil;
    
    //reset the timer...
    [self.sessionTimer invalidate];

    self.isTimerActive = NO;
    NSLog(@"stop timer...");
}

- (void)startTimer {
    [self.sessionTimer invalidate];
    if (self.sessionDate == nil) {
        self.sessionDate = [NSDate date];
    }
    self.currentInterval = 0.0;
    
    self.sessionTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(updateLabel)
                                                       userInfo:nil
                                                        repeats:YES];
    NSLog(@"start timer...");
    self.isTimerActive = YES;
}

- (void)resetTimer {
    [self stopTimer];
    self.sessionInterval = 0.0;
    [self updateLabel];
    
    NSLog(@"reset timer...");
}

- (void)updateLabel {
    self.currentInterval = -1*[self.sessionDate timeIntervalSinceNow];
//    self.timerLabel.text = [self stringFromTimeInterval:self.currentInterval];
    self.timerLabel.text = [FLUtility stringFromTimeInterval:self.currentInterval withBaseInterval:self.sessionInterval];
}
@end
