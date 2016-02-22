//
//  GobanViewController.h
//  Goban
//
//  Created by Raj Wilhoit on 3/17/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Goban.h"
#import "KGModal.h"

@interface GobanViewController : UIViewController

- (IBAction)pressedOptions:(id)sender;
- (void)drawBoardForNewMove:(int)rowOfNewMove andColumn:(int)columnOfNewMove;
- (void)markStonesAsDead;

@property (strong, nonatomic) IBOutlet UIButton *optionsButtonTop;
@property (strong, nonatomic) IBOutlet UIButton *optionsButtonBottom;
@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackCapturedStoneCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteCapturedStoneCountLabel;

@end
