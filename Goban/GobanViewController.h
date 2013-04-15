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

@interface GobanViewController : UIViewController {
}
- (IBAction)pressedBack:(id)sender;
- (IBAction)pressedResign:(id)sender;

-(void)drawBoardForNewMove:(int)rowValueOfNewMove andForColumn:(int)columnValueOfNewMove;
-(void)scoreGame;
-(void)startTimer;
-(void)timerCallback;
-(void)timeUp;

@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackCapturedStoneCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteCapturedStoneCountLabel;


@end
