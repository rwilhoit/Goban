//
//  MainMenuViewController.h
//  Goban
//
//  Created by Raj Wilhoit on 4/11/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController {
    
}

@property (strong, nonatomic) IBOutlet UIButton *gameButton;
@property (strong, nonatomic) IBOutlet UIButton *loadGameButton;
@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackStonesCapturedStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackStonesCapturedLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteStonesCapturedStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteStonesCapturedLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeLabel;

- (IBAction)pressedLoad:(id)sender;

@end
