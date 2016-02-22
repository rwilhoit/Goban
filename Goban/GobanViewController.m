//
//  GobanViewController.m
//  Goban
//
//  Created by Raj Wilhoit on 3/17/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "GobanViewController.h"
#import "GobanConstants.h"
#import "BoardSerializationUtility.h"

@interface GobanViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) Goban *goBoard;
@property (nonatomic, strong) NSTimer *gameClock;
@property (nonatomic) BOOL boardLoadRequest;
@property (nonatomic) BOOL currentlyMarkingStonesAsDead;
@property (nonatomic) BOOL currentlyScoringGame;
@property (nonatomic) BOOL topPlayerPressedOptions;

@end

@implementation GobanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goBoard = [[Goban alloc] init];
    
    [self layoutInterface];
    [self startTimer];
}

#pragma mark - UIGestureRecognizers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    int rowValue;
    int columnValue;
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInView:self.view];
        rowValue = (int)floor(touchPoint.x / GobanSpaceSize);
        columnValue = (int)floor((touchPoint.y - GobanMiddleOffsetSize) / GobanSpaceSize);
    }

    if (self.currentlyMarkingStonesAsDead && [self.goBoard isInBounds:rowValue andForColumnValue:columnValue]) {
        /*
         * Marking stones as dead
         */
        if([self.goBoard.goban[rowValue][columnValue] isEqualToString:GobanBlackSpotString]) {
            [self.goBoard markStoneClusterAsDeadFor:rowValue andForColumnValue:columnValue andForColor:GobanBlackSpotString];
        }
        else if([self.goBoard.goban[rowValue][columnValue] isEqualToString:GobanWhiteSpotString]) {
            [self.goBoard markStoneClusterAsDeadFor:rowValue andForColumnValue:columnValue andForColor:GobanWhiteSpotString];
        }
        [self drawBoardForNewMove:0 andColumn:0];
    }
    else if ([self.goBoard isLegalMove:rowValue andForColumnValue:columnValue]) {
        if([self.goBoard.turn isEqualToString:GobanBlackSpotString]) {
            [self playMoveAtRow:rowValue column:columnValue forColor:GobanBlackSpotString];
        }
        else {
            [self playMoveAtRow:rowValue column:columnValue forColor:GobanWhiteSpotString];
        }
    }
    
    [BoardSerializationUtility printBoardToConsole:self.goBoard.goban];
}

#pragma mark - Board Drawing

- (void)drawNewMoveOnBoardForRow:(int)rowOfNewMove andColumn:(int)columnOfNewMove {
    CALayer *stoneLayer = [CALayer layer];
    if([self.goBoard.goban[rowOfNewMove][columnOfNewMove] isEqualToString:GobanBlackSpotString]) {
        stoneLayer.frame = CGRectMake(rowOfNewMove * GobanSpaceSize,
                                      columnOfNewMove * GobanSpaceSize + GobanMiddleOffsetSize,
                                      GobanSpaceSize,
                                      GobanSpaceSize);
        stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
        [self.view.layer addSublayer:stoneLayer];
    }
    else if([self.goBoard.goban[rowOfNewMove][columnOfNewMove] isEqualToString:GobanWhiteSpotString]) {
        stoneLayer.frame = CGRectMake(rowOfNewMove * GobanSpaceSize,
                                      columnOfNewMove * GobanSpaceSize + GobanMiddleOffsetSize,
                                      GobanSpaceSize,
                                      GobanSpaceSize);
        stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
    }
    [self.view.layer addSublayer:stoneLayer];
}

- (void)drawAllMovesOnBoard {
    for(int i = 0 ;i < self.goBoard.goban.count; i++) {
        for(int j = 0; j < self.goBoard.goban.count; j++) {
            CALayer *stoneLayer = [CALayer layer];
            if([self.goBoard.goban[j][i] isEqualToString:GobanBlackSpotString]) {
                stoneLayer.frame = CGRectMake(j * GobanSpaceSize,
                                              i * GobanSpaceSize + GobanMiddleOffsetSize,
                                              GobanSpaceSize,
                                              GobanSpaceSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
            }
            else if([self.goBoard.goban[j][i] isEqualToString:GobanWhiteSpotString]) {
                stoneLayer.frame = CGRectMake(j * GobanSpaceSize,
                                              i * GobanSpaceSize + GobanMiddleOffsetSize,
                                              GobanSpaceSize,
                                              GobanSpaceSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
            }
            else if([self.goBoard.goban[j][i] isEqualToString:@"w"]) {
                stoneLayer.frame = CGRectMake(j * GobanSpaceSize,
                                              i * GobanSpaceSize + GobanMiddleOffsetSize,
                                              GobanSpaceSize,
                                              GobanSpaceSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
                stoneLayer.opacity = 0.5;
            }
            else if([self.goBoard.goban[j][i] isEqualToString:@"b"]) {
                stoneLayer.frame = CGRectMake(j * GobanSpaceSize,
                                              i * GobanSpaceSize + GobanMiddleOffsetSize,
                                              GobanSpaceSize,
                                              GobanSpaceSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
                stoneLayer.opacity = 0.5;
            }
            else if([self.goBoard.goban[j][i] isEqualToString:@"Wp"]) {
                stoneLayer.frame = CGRectMake(j * GobanSpaceSize + (GobanSpaceSize / 4),
                                              i * GobanSpaceSize + (GobanSpaceSize / 4) + GobanMiddleOffsetSize, GobanSpaceSize / 2,GobanSpaceSize / 2);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
            }
            else if([self.goBoard.goban[j][i] isEqualToString:@"Bp"]) {
                stoneLayer.frame = CGRectMake(j * GobanSpaceSize + GobanSpaceSize / 4,
                                              i * GobanSpaceSize + (GobanSpaceSize / 4) + GobanMiddleOffsetSize,
                                              GobanSpaceSize / 2,
                                              GobanSpaceSize/2);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
            }
            [self.view.layer addSublayer:stoneLayer];
        }
    }
}


- (void)playMoveAtRow:(int)row column:(int)column forColor:(NSString *)color {
    [self.goBoard playMoveAtRow:row column:column forColor:color];
    [self drawBoardForNewMove:row andColumn:column];
    if ([color isEqualToString:GobanBlackSpotString]) {
        self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.capturedWhiteStones];
    }
    else if ([color isEqualToString:GobanWhiteSpotString]) {
        self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.capturedBlackStones];
    }
}

- (void)drawBoard {
    CALayer *boardLayer = [CALayer layer];
    boardLayer.frame = CGRectMake(0, GobanMiddleOffsetSize, 768, 768);
    boardLayer.contents = (id) [UIImage imageNamed:GobanBoardImageFileName].CGImage;
    [self.view.layer addSublayer:boardLayer];
}

- (void)drawBoardForNewMove:(int)rowOfNewMove andColumn:(int)columnOfNewMove {
    if(!self.goBoard.redrawBoardNeeded) {
        [self drawNewMoveOnBoardForRow:rowOfNewMove andColumn:columnOfNewMove];
    }
    else {
        [self drawBoard];
        [self drawAllMovesOnBoard];
        self.goBoard.redrawBoardNeeded = NO;
    }
}

- (void)layoutInterface {
    // Add the main view image
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.frame = CGRectMake(0,GobanMiddleOffsetSize,768,768);
    sublayer.contents = (id) [UIImage imageNamed:GobanBoardImageFileName].CGImage;
    [self.view.layer addSublayer:sublayer];
    
    // Set the label colors
    self.blackCapturedStoneCountLabel.textColor = [UIColor blackColor];
    self.whiteCapturedStoneCountLabel.textColor = [UIColor blackColor];
    self.whiteRemainingTimeLabel.textColor = [UIColor blackColor];
    self.blackRemainingTimeLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //rotate labels in 180 degrees
    self.whiteCapturedStoneCountLabel.transform = CGAffineTransformMakeRotation(M_PI);
    self.whiteRemainingTimeLabel.transform = CGAffineTransformMakeRotation(M_PI);
    self.optionsButtonTop.transform = CGAffineTransformMakeRotation(M_PI);
    self.optionsButtonTop.transform = CGAffineTransformMakeRotation(M_PI);
}

#pragma mark - Action Sheet

- (void)pressedBack {
    //restore the board to it's previous state
    [self.goBoard back];
    
    self.goBoard.redrawBoardNeeded = YES;
    [self drawBoardForNewMove:0 andColumn:0];
    
    //Reset the number of captured stones
    self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.previousCapturedWhiteStones];
    self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.previousCapturedBlackStones];
}

- (void)resign {
    if([self.goBoard.turn isEqualToString:GobanBlackSpotString]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"White Wins!"
                                                        message:@"Black resigned"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Black Wins!"
                                                        message:@"White resigned"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)pressedResign {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                initWithTitle:@"Are you sure?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Yes", @"No", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    if(self.topPlayerPressedOptions) {
        actionSheet.transform = CGAffineTransformMakeRotation(M_PI);
        self.topPlayerPressedOptions = NO;
    }
    
    [actionSheet showInView:self.view];
}

- (void)pressedPass
{
    //Get the current turn and set the pass variable to true then switch the turn
    /*
    if([goBoard.turn isEqualToString:GobanBlackSpotString] && ![self.passButton.title isEqualToString:@"Done"])
    {
        [goBoard setBlackPassed:YES];
        [goBoard setTurn:GobanWhiteSpotString];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Black Passed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([goBoard.turn isEqualToString:GobanWhiteSpotString] && ![self.passButton.title isEqualToString:@"Done"])
    {
        [goBoard setWhitePassed:YES];
        [goBoard setTurn:GobanBlackSpotString];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"White Passed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //else nothing
    }
    
    //Change the state of the pass button if both are true and wait for the user to press it
    if(goBoard.whitePassed && goBoard.blackPassed && ![self.passButton.title isEqualToString:@"Done"])
    {
        [self.passButton setTitle:@"Done"];
        [gameClock invalidate];
        [self setCurrentlyMarkingStonesAsDead:YES];
    }
    else if([self.passButton.title isEqualToString:@"Done"])
    {
        [self scoreGame];
    }
    else
    {
        //else nothing
    } */
}

- (IBAction)pressedOptions:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Undo", @"Pass", @"Resign", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    if([sender tag] == 1) {
        actionSheet.transform = CGAffineTransformMakeRotation(M_PI);
        self.topPlayerPressedOptions = YES;
    }
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet.title isEqualToString:@"Options"]) {
        switch (buttonIndex) {
            case 0:
                [self pressedBack];
                break;
            case 1:
                [self pressedPass];
                break;
            case 2:
                [self pressedResign];
                break;
        }
    }
    else if([actionSheet.title isEqualToString:@"Are you sure?"]) {
        switch (buttonIndex) {
            case 0:
                [self resign];
                break;
            case 1:
                break;
        }
    }
}

#pragma mark - Game Clock

- (void) startTimer {
    self.gameClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(timerCallback)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)timerCallback {
    NSMutableString *result = [NSMutableString string];
    int iMinutes = 25;
    int iSeconds = 0;
    if([self.goBoard.turn isEqualToString:GobanBlackSpotString]) {
        iMinutes = [[self.blackRemainingTimeLabel.text substringToIndex:2] intValue];
        iSeconds = [[self.blackRemainingTimeLabel.text substringFromIndex:3] intValue];
        if(iMinutes < 0) {
            [self timeUp];
        }
        else if(iSeconds <= 0) {
            iMinutes--;
            iSeconds = 59;
        }
        else {
            iSeconds--;
        }
        
        if(iMinutes < 0) {
            [self.gameClock invalidate];
            self.gameClock = nil;
            [self timeUp];
        }
        else {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds];
            self.blackRemainingTimeLabel.text = result;
        }
    }
    else if([self.goBoard.turn isEqualToString:GobanWhiteSpotString]) {
        iMinutes = [[self.whiteRemainingTimeLabel.text substringToIndex:2] intValue];
        iSeconds = [[self.whiteRemainingTimeLabel.text substringFromIndex:3] intValue];
        if(iSeconds <= 0) {
            iMinutes--;
            iSeconds = 59;
        }
        else {
            iSeconds--;
        }
        
        if(iMinutes < 0) {
            [self.gameClock invalidate];
            self.gameClock = nil;
            [self timeUp];
        }
        else {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds];
            self.whiteRemainingTimeLabel.text = result;
        }
    }
}

- (void)timeUp {
    NSString *title = nil;
    NSString *message = nil;
    NSString *cancelButtonTitle = @"OK";
    if([self.goBoard.turn isEqualToString:GobanBlackSpotString]) {
        title = @"White Wins!";
        message = @"Black ran out of time!";
    }
    else {
        title = @"Black Wins!";
        message = @"White ran out of time!";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    [alert show];

}

#pragma mark - Game Scorings

-(void)scoreGame {
    NSLog(@"Scoring game");
    int points = 0;
    NSMutableArray *emptySpaces = [[NSMutableArray alloc] init];
    NSString *addingPointsFor = [[NSMutableString alloc] init];
    int counter = 0;
    
    //Turn off mark stones as dead
    [self setCurrentlyMarkingStonesAsDead:NO];
    
    for(int i = 0 ; i < self.goBoard.goban.count; i++) {
        for(int j = 0; j< self.goBoard.goban.count; j++) {
            if([self.goBoard.goban[j][i] isEqualToString:GobanEmptySpotString] ||
               [self.goBoard.goban[j][i] isEqualToString:@"w"] ||
               [self.goBoard.goban[j][i] isEqualToString:@"b"]) {
                if([addingPointsFor isEqualToString:GobanBlackSpotString]) {
                    //Mark the locations to draw half-stones for black at this position
                    self.goBoard.goban[j][i] = @"Bp";
                    [self.goBoard setBlackStones:(self.goBoard.blackStones+1)];
                }
                else if([addingPointsFor isEqualToString:GobanWhiteSpotString]) {
                    //Just draw a half-stone for white at this position
                    self.goBoard.goban[j][i] = @"Wp";
                    [self.goBoard setWhiteStones:(self.goBoard.whiteStones+1)];
                }
                else {
                    Stone *emptySpace = [[Stone alloc] initWithWithRow:j column:i];
                    [emptySpaces addObject:emptySpace];
                    points++;
                }
            }
            else if([self.goBoard.goban[j][i] isEqualToString:GobanBlackSpotString])
            {
                //Marking any free spaces as black's points
                if(points > 0)
                {
                    //NSLog(@"Points need accounting for (black)");
                    while([emptySpaces count] > 0)
                    {
                        Stone *emptySpace = emptySpaces[0];
                        self.goBoard.goban[emptySpace.row][emptySpace.column] = @"Bp";
                        [emptySpaces removeObjectAtIndex:0];
                    }
                }
                addingPointsFor = GobanBlackSpotString;
                [self.goBoard setBlackStones:(self.goBoard.blackStones+points+1)];
                points = 0;
            }
            else if([self.goBoard.goban[j][i] isEqualToString:GobanWhiteSpotString])
            {
                //Marking any free spaces as white's points
                if(points > 0)
                {
                   // NSLog(@"Points need accounting for (white)");
                    while([emptySpaces count] > 0)
                    {
                        Stone *emptySpace = emptySpaces[0];
                        self.goBoard.goban[emptySpace.row][emptySpace.column] = @"Wp";
                        [emptySpaces removeObjectAtIndex:0];
                    }
                }
                addingPointsFor = GobanWhiteSpotString;
                [self.goBoard setWhiteStones:(self.goBoard.whiteStones+points+1)];
                points = 0;
            }
        }
        addingPointsFor = @"Nobody";
    }
    
    //Redraw the board ot show the scored points
    [self.goBoard setRedrawBoardNeeded:YES];
    [self drawBoardForNewMove:0 andColumn:0];

    //Convert both to floats and add the komi value to white
    int blackScore = (double)self.goBoard.blackStones + (double)self.goBoard.capturedWhiteStones;
    double whiteScore = (double)self.goBoard.whiteStones + (double)self.goBoard.capturedBlackStones + self.goBoard.komi;
    
    NSString *pointTally = [NSString stringWithFormat:@"Black: %d points + %d captures = %d\nWhite: %d points + %d captures + %.1f komi = %.1f", self.goBoard.blackStones, self.goBoard.capturedWhiteStones, blackScore, self.goBoard.whiteStones, self.goBoard.capturedBlackStones, self.goBoard.komi, whiteScore];
   
    NSString *title = nil;
    NSString *cancelButtonTitle = @"OK";
    if(blackScore > whiteScore) {
        title = @"Black wins!";
    }
    else if(whiteScore > blackScore) {
        title = @"White wins!";
    }
    else {
        title = @"Tie?";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:pointTally
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    [alert show];
}

@end
