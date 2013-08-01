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
        // This was written to load the game from the server and can probably be mostly deleted 
        
        GobanViewController *gobanViewController = (GobanViewController *)[[segue destinationViewController] topViewController];
        [gobanViewController setBoardLoadRequest:YES];
        NSLog(@"Load game selected");

        //[gobanViewController loadBoardFromServer];

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
    infoLabel.text = @"Goban is a multiplayer tabletop Go app.\n Select new or load game to play! \n This version uses Chinese scoring.";
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

    // Set the label colors
    //self.blackStonesCapturedLabel.textColor = [UIColor blackColor];
    //self.whiteStonesCapturedLabel.textColor = [UIColor blackColor];
    //self.view.backgroundColor = [UIColor whiteColor];
    
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
}

@end
