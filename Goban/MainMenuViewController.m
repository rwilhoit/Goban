//
//  MainMenuViewController.m
//  Goban
//
//  Created by Raj Wilhoit on 4/11/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "MainMenuViewController.h"
#import "GobanViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

@synthesize gameButton;
@synthesize loadGameButton;
@synthesize blackRemainingTimeStaticLabel;
@synthesize blackRemainingTimeLabel;
@synthesize blackStonesCapturedStaticLabel;
@synthesize blackStonesCapturedLabel;
@synthesize whiteRemainingTimeStaticLabel;
@synthesize whiteRemainingTimeLabel;
@synthesize whiteStonesCapturedStaticLabel;
@synthesize whiteStonesCapturedLabel;
@synthesize loadGameOnLoad;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"loadGameSegue"])
    {
        GobanViewController *gobanViewController = (GobanViewController *)[[segue destinationViewController] topViewController];
        [gobanViewController setBoardLoadRequest:YES];
        NSLog(@"Load game selected");

        // Update the view (don't think this is necessary)
        //[gobanViewController up
        [gobanViewController loadBoardFromServer];

    }
    else if([[segue identifier] isEqualToString:@"startGameSegue"])
    {
        GobanViewController *gobanViewController = (GobanViewController *)[[segue destinationViewController] topViewController];
        [gobanViewController setBoardLoadRequest:NO];
        NSLog(@"New game selected");
    }

    else
    {
        NSLog(@"Load failed");
    }
    
}

- (void)showAction:(id)sender{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Welcome to Goban!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"Goban is an multiplayer tabletop Go app.\n Just select new or load game to play!";
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

- (void)viewDidLoad
{
    [self showAction:nil];
    
    // Add the main view image
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.frame = CGRectMake(0,0,768,768);
    sublayer.contents = (id) [UIImage imageNamed:@"Goban.png"].CGImage;
    [self.view.layer addSublayer:sublayer];

    // Draw the buttons
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [gameButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [gameButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [loadGameButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [loadGameButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];

    //Set colors for buttons and background
    self.view.backgroundColor = [UIColor blackColor];
    self.blackRemainingTimeLabel.textColor = [UIColor orangeColor];
    self.blackRemainingTimeStaticLabel.textColor = [UIColor orangeColor];
    self.blackStonesCapturedLabel.textColor = [UIColor orangeColor];
    self.blackStonesCapturedStaticLabel.textColor = [UIColor orangeColor];
    self.whiteRemainingTimeLabel.textColor = [UIColor orangeColor];
    self.whiteRemainingTimeStaticLabel.textColor = [UIColor orangeColor];
    self.whiteStonesCapturedLabel.textColor = [UIColor orangeColor];
    self.whiteStonesCapturedStaticLabel.textColor = [UIColor orangeColor];
    [self.blackRemainingTimeLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.blackRemainingTimeStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteRemainingTimeLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteRemainingTimeStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteStonesCapturedLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteStonesCapturedStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.blackStonesCapturedLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.blackStonesCapturedStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];


    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedLoad:(id)sender
{
    NSLog(@"Pressed load");
    //Need to set something
    
    // Need to load a goban object based on what's on the server
    
}

@end
