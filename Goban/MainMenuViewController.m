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
