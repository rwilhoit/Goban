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


@interface GobanViewController : UIViewController {
    NSMutableData *responseData;
    NSString *serverId;
    BOOL boardLoadRequest;
    BOOL currentlyMarkingStonesAsDead;
}
- (IBAction)pressedBack:(id)sender;
- (IBAction)pressedResign:(id)sender;
- (IBAction)pressedPass:(id)sender;

-(void)drawBoardForNewMove:(int)rowValueOfNewMove andForColumn:(int)columnValueOfNewMove;
-(void)scoreGame;
-(void)markStonesAsDead;
-(void)startTimer;
-(void)timerCallback;
-(void)timeUp;
-(void)saveBoardToServer;
-(void)loadBoardFromServer;

@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackCapturedStonesStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteCapturedStonesStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeStaticLabel;
@property (strong, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *resignButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *passButton;
@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackCapturedStoneCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteCapturedStoneCountLabel;
@property (nonatomic) BOOL boardLoadRequest;
@property (nonatomic) BOOL currentlyMarkingStonesAsDead;
@property (nonatomic) BOOL currentlyScoringGame;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSString *serverId;


@end
