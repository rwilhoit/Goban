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
    // Need to load a goban object based on what's on the server
    
}

@end
