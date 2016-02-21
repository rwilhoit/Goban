//
//  GobanViewController.m
//  Goban
//
//  Created by Raj Wilhoit on 3/17/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "GobanViewController.h"

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
    
    [self drawUI];
    
    //Initialize the goBoard and populate it
    self.goBoard = [[Goban alloc] init];

    [self initializeBoard];
    self.goBoard.moveNumber = 0;
    self.goBoard.whiteStones = 0;
    self.goBoard.blackStones = 0;
    self.goBoard.turn = @"B";
    
    //Set the komi count to a default (for now) of 6.5
    self.goBoard.komi = 6.5;
    
    // Start the timer
    [self startTimer];
}

//Where the stones are played
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    __block int rowValue;
    __block int columnValue;
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get a single touch and it's location
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.view];
        NSLog(@"touchPoint: %@, x: %f, y: %f", NSStringFromCGPoint(touchPoint), touchPoint.x, touchPoint.y-MIDDLE_OFFSET); //Give me the coordinates of where the user touched
        NSLog(@"We want to draw at point: %d, %d", (int)floor(touchPoint.x/40.4210526316), (int)floor((touchPoint.y-MIDDLE_OFFSET)/40.4210526316));
        //Get specific coordinates from touch event
        rowValue = (int)floor(touchPoint.x/40.4210526316);
        columnValue = (int)floor((touchPoint.y-MIDDLE_OFFSET)/40.4210526316);
    }];

    //Check if we are marking stones as dead
    if(self.currentlyMarkingStonesAsDead && [self.goBoard isInBounds:rowValue andForColumnValue:columnValue])
    {
        NSLog(@"Marking stone as dead");
        if([self.goBoard.goban[rowValue][columnValue] isEqualToString:@"B"]) {
            [self.goBoard markStoneClusterAsDeadFor:rowValue andForColumnValue:columnValue andForColor:@"B"];
            [self drawBoardForNewMove:0 andForColumn:0];
        }
        else if([self.goBoard.goban[rowValue][columnValue] isEqualToString:@"W"]) {
            [self.goBoard markStoneClusterAsDeadFor:rowValue andForColumnValue:columnValue andForColor:@"W"];
            [self drawBoardForNewMove:0 andForColumn:0];
        }
    }
    //Check if new move is legal
    else if([self.goBoard isLegalMove:rowValue andForColumnValue:columnValue]) {
        if([self.goBoard.turn isEqualToString:@"B"]) {
            //Save the previous state of the board
            self.goBoard.previousStateOfBoard = [[NSMutableArray alloc] initWithArray:self.goBoard.goban copyItems:YES];
            
            //Play black's turn
            self.goBoard.goban[rowValue][columnValue] = @"B";
            
            //Increment the move number
            self.goBoard.moveNumber = self.goBoard.moveNumber + 1;
            
            //Check the life of adjacent pieces of the opposite color
            [self.goBoard checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
            
            //Draw the entire board again
            [self drawBoardForNewMove:rowValue andForColumn:columnValue];
            
            //Update the captured stone count
            self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.capturedWhiteStones];
            
            //Set the pass variables to NO
            [self.goBoard setBlackPassed:NO];
            [self.goBoard setWhitePassed:NO];
            
            //Set to white's turn
            NSLog(@"Set to white's turn");
            [self.goBoard setTurn:@"W"];
        }
        else {
            //Save the previous state of the board
            self.goBoard.previousStateOfBoard = [[NSMutableArray alloc] initWithArray:self.goBoard.goban copyItems:YES];
            
            //Play white's turn
            NSLog(@"Played white's turn");
            self.goBoard.goban[rowValue][columnValue] = @"W";
            
            //Check the life of adjacent pieces of the opposite color
            [self.goBoard checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
            
            //Increment the move number
            self.goBoard.moveNumber = self.goBoard.moveNumber + 1;
            
            //Draw the entire board again, or just the new move
            [self drawBoardForNewMove:rowValue andForColumn:columnValue];
            
            //Update the captured stone count
            self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.capturedBlackStones];
            
            //Set the pass variables to NO
            self.goBoard.blackPassed = NO;
            self.goBoard.whitePassed = NO;
            
            //Set to black's turn
            NSLog(@"Set to black's turn");
            self.goBoard.turn = @"B";
        }
    }
    
    //Print results
    [self.goBoard printBoardToConsole];
    
}

-(void)drawBoardForNewMove:(int)rowValueOfNewMove andForColumn:(int)columnValueOfNewMove {
    //Check it we need to redraw the board or just add a stone to it
    float stoneSize = 40.4210526316;
    NSLog(@"Stone size: %f", stoneSize);
    if(!self.goBoard.redrawBoardNeeded)
    {
        //How do I know which position to draw at?
        if([self.goBoard.goban[rowValueOfNewMove][columnValueOfNewMove] isEqualToString:@"B"])
        {
            CALayer *stoneLayer = [CALayer layer];
            stoneLayer.frame = CGRectMake(rowValueOfNewMove*stoneSize,columnValueOfNewMove*stoneSize + MIDDLE_OFFSET,stoneSize,stoneSize);
            stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
            [self.view.layer addSublayer:stoneLayer];
        }
        else if([self.goBoard.goban[rowValueOfNewMove][columnValueOfNewMove] isEqualToString:@"W"])
        {    
            CALayer *stoneLayer = [CALayer layer];
            stoneLayer.frame = CGRectMake(rowValueOfNewMove*stoneSize,columnValueOfNewMove*stoneSize + MIDDLE_OFFSET,stoneSize,stoneSize);
            stoneLayer.contents = (id) [UIImage imageNamed:@"whiteStone.png"].CGImage;
            [self.view.layer addSublayer:stoneLayer];
        }
        else
        {
            //Else nothing. This should never be reached.
        }
    }
    else
    {
        CALayer *boardLayer = [CALayer layer];
        boardLayer.frame = CGRectMake(0,MIDDLE_OFFSET,768,768);
        boardLayer.contents = (id) [UIImage imageNamed:@"Goban.png"].CGImage;
        [self.view.layer addSublayer:boardLayer];
    
        // Check the positions you need to draw at
        NSLog(@"Drawing stones");
        for(int i=0;i<[self.goBoard.goban count];i++)
        {
            for(int j=0;j<[self.goBoard.goban count];j++)
            {
                if([self.goBoard.goban[j][i] isEqualToString:@"B"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize + MIDDLE_OFFSET,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([self.goBoard.goban[j][i] isEqualToString:@"W"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize + MIDDLE_OFFSET,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"whiteStone.png"].CGImage;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([self.goBoard.goban[j][i] isEqualToString:@"w"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize + MIDDLE_OFFSET,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"whiteStone.png"].CGImage;
                    stoneLayer.opacity = 0.5;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([self.goBoard.goban[j][i] isEqualToString:@"b"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize + MIDDLE_OFFSET,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
                    stoneLayer.opacity = 0.5;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([self.goBoard.goban[j][i] isEqualToString:@"Wp"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize+stoneSize/4,i*stoneSize+(stoneSize/4) + MIDDLE_OFFSET,stoneSize/2,stoneSize/2);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"whiteStone.png"].CGImage;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([self.goBoard.goban[j][i] isEqualToString:@"Bp"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize+stoneSize/4,i*stoneSize+(stoneSize/4) + MIDDLE_OFFSET,stoneSize/2,stoneSize/2);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
                    [self.view.layer addSublayer:stoneLayer];
                }
            }
        }
        self.goBoard.redrawBoardNeeded = NO;
    }
}

- (void)drawUI {
    // Add the main view image
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.frame = CGRectMake(0,MIDDLE_OFFSET,768,768);
    sublayer.contents = (id) [UIImage imageNamed:@"Goban.png"].CGImage;
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

- (NSString *)getCurrentTime {
    //Set the board creation time
    CFGregorianDate currentGregorianDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
    NSString *currentDate =[NSString stringWithFormat:@"%d-%d-%d at %02d:%02d", (int)currentGregorianDate.month, (int)currentGregorianDate.day, (int)currentGregorianDate.year, currentGregorianDate.hour, currentGregorianDate.minute];
    NSLog(@"Current Date: %@", currentDate);
    
    return currentDate;
}

- (void)initializeBoard {
    
    self.goBoard.goban = [NSMutableArray arrayWithObjects:
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil],
                     [NSMutableArray arrayWithObjects:@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",@"+",nil], nil];
    [self.goBoard printBoardToConsole];
}

- (void)pressedBack {
    NSLog(@"Pressed back");
    
    //restore the board to it's previous state
    [self.goBoard back];
    
    //If anything breaks the back button, this would be it
    self.goBoard.redrawBoardNeeded = YES;
    [self drawBoardForNewMove:0 andForColumn:0];
    
    //Reset the number of captured stones
    self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.previousCapturedWhiteStones];
    self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", self.goBoard.previousCapturedBlackStones];
}

- (void)resign {
    if([self.goBoard.turn isEqualToString:@"B"]) {
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
    if([goBoard.turn isEqualToString:@"B"] && ![self.passButton.title isEqualToString:@"Done"])
    {
        [goBoard setBlackPassed:YES];
        [goBoard setTurn:@"W"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Black Passed" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([goBoard.turn isEqualToString:@"W"] && ![self.passButton.title isEqualToString:@"Done"])
    {
        [goBoard setWhitePassed:YES];
        [goBoard setTurn:@"B"];
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
        switch (buttonIndex)
        {
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
    else if([actionSheet.title isEqualToString:@"Are you sure?"])
    {
        switch (buttonIndex)
        {
            case 0:
                [self resign];
                break;
            case 1:
                break;
        }
    }
    else
    {
        //else nothing
    }

}

- (void) startTimer {
    self.gameClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(timerCallback)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)timerCallback {
    NSMutableString *result = [[NSMutableString alloc] init];
    int iMinutes = 25;
    int iSeconds = 0;
    if([self.goBoard.turn isEqualToString:@"B"]) //Countdown blacks timer if it is black's turn
    {
        //NSLog(@"Minutes: %@, Seconds: %@", [self.blackRemainingTimeLabel.text substringToIndex:2], [self.blackRemainingTimeLabel.text substringFromIndex:3]);
        iMinutes = [[self.blackRemainingTimeLabel.text substringToIndex:2] integerValue];
        iSeconds = [[self.blackRemainingTimeLabel.text substringFromIndex:3] integerValue];
        //NSLog(@"int representation of iSeconds: %d", iSeconds);
        if(iMinutes < 0)
        {
            [self timeUp];
        }
        else if(iSeconds <= 0)
        {
            iMinutes--;
            iSeconds = 59;
            //NSLog(@"Reset iSeconds %d", iSeconds);
        }
        else
        {
            iSeconds--;
        }
        
        if(iMinutes < 0)
        {
            [self.gameClock invalidate];
            [self timeUp];
        }
        else
        {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds]; //%d or %i both is ok.
            self.blackRemainingTimeLabel.text = result;
            //NSLog(@"Remaining time of black: %@", self.blackRemainingTimeLabel.text);
        }
    }
    else if([self.goBoard.turn isEqualToString:@"W"])
    {
        //NSLog(@"Minutes: %@, Seconds: %@", [self.whiteRemainingTimeLabel.text substringToIndex:2], [self.whiteRemainingTimeLabel.text substringFromIndex:3]);
        iMinutes = [[self.whiteRemainingTimeLabel.text substringToIndex:2] integerValue];
        iSeconds = [[self.whiteRemainingTimeLabel.text substringFromIndex:3] integerValue];
        //NSLog(@"int representation of iSeconds: %d", iSeconds);
        if(iSeconds <= 0)
        {
            iMinutes--;
            iSeconds = 59;
            //SLog(@"Reset iSeconds %d", iSeconds);
        }
        else
        {
            iSeconds--;
        }
        
        if(iMinutes < 0)
        {
            [self.gameClock invalidate];
            [self timeUp];
        }
        else
        {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds]; //%d or %i both is ok.
            self.whiteRemainingTimeLabel.text = result;
            //NSLog(@"Remaining time of white: %@", self.whiteRemainingTimeLabel.text);
        }
    }
    else
    {
        //Do nothing
    }
}

- (void)timeUp
{
    if([self.goBoard.turn isEqualToString:@"B"])
    {
        //Show warning
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"White Wins!" message:@"Black ran out of time!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Show warning
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Black Wins!" message:@"White ran out of time!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

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
            if([self.goBoard.goban[j][i] isEqualToString:@"+"] ||
               [self.goBoard.goban[j][i] isEqualToString:@"w"] ||
               [self.goBoard.goban[j][i] isEqualToString:@"b"]) {
                if([addingPointsFor isEqualToString:@"B"]) {
                    //Mark the locations to draw half-stones for black at this position
                    self.goBoard.goban[j][i] = @"Bp";
                    [self.goBoard setBlackStones:(self.goBoard.blackStones+1)];
                }
                else if([addingPointsFor isEqualToString:@"W"]) {
                    //Just draw a half-stone for white at this position
                    self.goBoard.goban[j][i] = @"Wp";
                    [self.goBoard setWhiteStones:(self.goBoard.whiteStones+1)];
                }
                else {
                    Stone *emptySpace = [[Stone alloc] init];
                    emptySpace.rowValue = j;
                    emptySpace.columnValue = i;
                    [emptySpaces addObject:emptySpace];
                    points++;
                }
            }
            else if([self.goBoard.goban[j][i] isEqualToString:@"B"])
            {
                //Marking any free spaces as black's points
                if(points > 0)
                {
                    //NSLog(@"Points need accounting for (black)");
                    while([emptySpaces count] > 0)
                    {
                        Stone *emptySpace = emptySpaces[0];
                        self.goBoard.goban[emptySpace.rowValue][emptySpace.columnValue] = @"Bp";
                        [emptySpaces removeObjectAtIndex:0];
                    }
                }
                addingPointsFor = @"B";
                [self.goBoard setBlackStones:(self.goBoard.blackStones+points+1)];
                points = 0;
            }
            else if([self.goBoard.goban[j][i] isEqualToString:@"W"])
            {
                //Marking any free spaces as white's points
                if(points > 0)
                {
                   // NSLog(@"Points need accounting for (white)");
                    while([emptySpaces count] > 0)
                    {
                        Stone *emptySpace = emptySpaces[0];
                        self.goBoard.goban[emptySpace.rowValue][emptySpace.columnValue] = @"Wp";
                        [emptySpaces removeObjectAtIndex:0];
                    }
                }
                addingPointsFor = @"W";
                [self.goBoard setWhiteStones:(self.goBoard.whiteStones+points+1)];
                points = 0;
            }
            else
            {
                //Else nothing
            }
        }
        addingPointsFor = @"Nobody";
    }
    
    //Redraw the board ot show the scored points
    [self.goBoard setRedrawBoardNeeded:YES];
    [self drawBoardForNewMove:0 andForColumn:0];

    //Convert both to floats and add the komi value to white
    int blackScore = (double)self.goBoard.blackStones + (double)self.goBoard.capturedWhiteStones;
    double whiteScore = (double)self.goBoard.whiteStones + (double)self.goBoard.capturedBlackStones + self.goBoard.komi;
    
    NSString *pointTally = [NSString stringWithFormat:@"Black: %d points + %d captures = %d\nWhite: %d points + %d captures + %.1f komi = %.1f", self.goBoard.blackStones, self.goBoard.capturedWhiteStones, blackScore, self.goBoard.whiteStones, self.goBoard.capturedBlackStones, self.goBoard.komi, whiteScore];
   
    if(blackScore > whiteScore)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Black Wins!" message:pointTally delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(whiteScore > blackScore)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"White Wins!" message:pointTally delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tie?" message:pointTally delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
