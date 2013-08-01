//
//  MainMenuViewController.h
//  Goban
//
//  Created by Raj Wilhoit on 4/11/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController {
    BOOL loadGameOnLoad;
    
}

@property (strong, nonatomic) IBOutlet UIButton *gameButton;
@property (strong, nonatomic) IBOutlet UIButton *loadGameButton;

@property (nonatomic) BOOL loadGameOnLoad;

- (IBAction)pressedLoad:(id)sender;
- (void)showAction:(id)sender;

@end
