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
#define MIDDLE_OFFSET 96


@interface GobanViewController : UIViewController {
    NSMutableData *responseData;
    NSString *serverId;
    BOOL boardLoadRequest;
    BOOL currentlyMarkingStonesAsDead;
    BOOL currentlyScoringGame;
    BOOL topPlayerPressedOptions;
}

//Actions
- (IBAction)pressedOptions:(id)sender;

//Backend
-(void)drawBoardForNewMove:(int)rowValueOfNewMove andForColumn:(int)columnValueOfNewMove;
-(void)scoreGame;
-(void)markStonesAsDead;
-(void)startTimer;
-(void)timerCallback;
-(void)timeUp;
-(void)saveBoardToServer;
-(void)loadBoardFromServer;

//Menu buttons
- (void)pressedBack;
- (void)pressedResign;
- (void)pressedPass;

@property (strong, nonatomic) IBOutlet UIButton *optionsButtonTop;
@property (strong, nonatomic) IBOutlet UIButton *optionsButtonBottom;
@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackCapturedStoneCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteCapturedStoneCountLabel;
@property (nonatomic) BOOL boardLoadRequest;
@property (nonatomic) BOOL currentlyMarkingStonesAsDead;
@property (nonatomic) BOOL currentlyScoringGame;
@property (nonatomic) BOOL topPlayerPressedOptions;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSString *serverId;

@end
