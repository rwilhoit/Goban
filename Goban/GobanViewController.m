//
//  GobanViewController.m
//  Goban
//
//  Created by Raj Wilhoit on 3/17/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "GobanViewController.h"


@interface GobanViewController ()

@end

@implementation GobanViewController

//Go board declared as a global variable
Goban *goBoard;
NSTimer *gameClock;

- (void)viewDidLoad
{
    // Add the main view image    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    //sublayer.frame = CGRectMake(self.view.layer.bounds.origin.x,self.view.layer.bounds.origin.y,self.view.layer.bounds.size.width, self.view.layer.bounds.size.height);
    sublayer.frame = CGRectMake(0,0,768,768);
    sublayer.contents = (id) [UIImage imageNamed:@"Goban.png"].CGImage;
    [self.view.layer addSublayer:sublayer];
    
    //Initialize the goBoard and populate it
    goBoard = [[Goban alloc] init];

    goBoard.goban = [NSMutableArray arrayWithObjects:
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
    
     [goBoard printBoardToConsole];

    //Set the moveNumber
    [goBoard setMoveNumber:0];
    NSLog(@"Move number: %d", goBoard.moveNumber);
    
    //Set the number of white stones
    [goBoard setWhiteStones:0];
    
    //Set the number of black stones
    [goBoard setBlackStones:0];
    
    //Set the number of captured white stones
    [goBoard setCapturedWhiteStones:0];
    
    //Set the number of captured black stones
    [goBoard setCapturedBlackStones:0];
    
    //Set the komi count to a default (for now) of 6.5
    [goBoard setKomi:6.5];
    
    //Set it to black's turn
    [goBoard setTurn:@"B"];
    
    //Set redraw needed
    [goBoard setRedrawBoardNeeded:NO];
    
    //Start the timer
    [self startTimer];
    
     [super viewDidLoad];
}

//Where the stones are played
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    __block int rowValue;
    __block int columnValue;
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get a single touch and it's location
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.view];
        NSLog(@"touchPoint: %@, x: %f, y: %f", NSStringFromCGPoint(touchPoint), touchPoint.x, touchPoint.y); //Give me the coordinates of where the user touched
        NSLog(@"We want to draw at point: %d, %d", (int)floor(touchPoint.x/40.4210526316), (int)floor(touchPoint.y/40.4210526316));
        //Get specific coordinates from touch event
        rowValue = (int)floor(touchPoint.x/40.4210526316);
        columnValue = (int)floor(touchPoint.y/40.4210526316);
    }];
        
    NSLog(@"Row coordinate: %d", rowValue);
    NSLog(@"Column coordinate: %d", columnValue);
    
    //Check if new move is legal
    if([goBoard isLegalMove:rowValue andForColumnValue:columnValue])
    {
        if([goBoard.turn isEqualToString:@"B"])
        {
            //Save the previous state of the board
            goBoard.previousStateOfBoard = [[NSMutableArray alloc] initWithArray:goBoard.goban copyItems:YES];
            
            //Play black's turn
            NSLog(@"Played black's turn");
            goBoard.goban[rowValue][columnValue] = @"B";
            
            if([goBoard.previousStateOfBoard[rowValue][columnValue] isEqualToString:goBoard.goban[rowValue][columnValue]])
            {
                NSLog(@"PREVIOUS STATE OF THE BOARD DID NOT SAVE");
            }
            else
            {
                NSLog(@"PREVIOUS STATE OF THE BOARD SUCCESSFULLY SAVED: PREVIOUS WAS %@ AND NOW IS %@", goBoard.previousStateOfBoard[rowValue][columnValue], goBoard.goban[rowValue][columnValue]);
            }
            
            //Increment the move number
            NSLog(@"Incrementing the move number: %d", goBoard.moveNumber);
            [goBoard setMoveNumber:(goBoard.moveNumber+1)];
            NSLog(@"Incremented move number: %d", goBoard.moveNumber);
            
            //Check the life of adjacent pieces of the opposite color
            [goBoard checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
            
            //Draw the entire board again
            [self drawBoardForNewMove:rowValue andForColumn:columnValue];
            
            //Update the captured stone count
            self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", goBoard.capturedWhiteStones];
            
            //Set to white's turn
            NSLog(@"Set to white's turn");
            [goBoard setTurn:@"W"];
        }
        else
        {
            //Save the previous state of the board
            goBoard.previousStateOfBoard = [[NSMutableArray alloc] initWithArray:goBoard.goban copyItems:YES];
            
            //Play white's turn
            NSLog(@"Played white's turn");
            goBoard.goban[rowValue][columnValue] = @"W";
            
            if([goBoard.previousStateOfBoard[rowValue][columnValue] isEqualToString:goBoard.goban[rowValue][columnValue]])
            {
                NSLog(@"PREVIOUS STATE OF THE BOARD DID NOT SAVE");
            }
            else
            {
                NSLog(@"PREVIOUS STATE OF THE BOARD SUCCESSFULLY SAVED: PREVIOUS WAS %@ AND NOW IS %@", goBoard.previousStateOfBoard[rowValue][columnValue], goBoard.goban[rowValue][columnValue]);
            }
            
            //Check the life of adjacent pieces of the opposite color
            [goBoard checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
            
            //Increment the move number
            NSLog(@"Incrementing the move number: %d", goBoard.moveNumber);
            [goBoard setMoveNumber:(goBoard.moveNumber+1)];
            NSLog(@"Incremented move number: %d", goBoard.moveNumber);
            
            //Draw the entire board again, or just the new move
            [self drawBoardForNewMove:rowValue andForColumn:columnValue];
            
            //Update the captured stone count
            self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", goBoard.capturedBlackStones];
            
            //Set to black's turn
            NSLog(@"Set to black's turn");
            [goBoard setTurn:@"B"];
        }
    }
    
    //Print results
    [goBoard printBoardToConsole];
     
}

-(void)drawBoardForNewMove:(int)rowValueOfNewMove andForColumn:(int)columnValueOfNewMove
{
    //Check it we need to redraw the board or just add a stone to it
    float stoneSize = 40.4210526316;
    NSLog(@"Stone size: %f", stoneSize);
    if(!goBoard.redrawBoardNeeded)
    {
        NSLog(@"Drawing just 1 new stone to the board");
        //How do I know which position to draw at?
        if([goBoard.goban[rowValueOfNewMove][columnValueOfNewMove] isEqualToString:@"B"])
        {
            CALayer *stoneLayer = [CALayer layer];
            stoneLayer.frame = CGRectMake(rowValueOfNewMove*stoneSize,columnValueOfNewMove*stoneSize,stoneSize,stoneSize);
            stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
            [self.view.layer addSublayer:stoneLayer];
        }
        else if([goBoard.goban[rowValueOfNewMove][columnValueOfNewMove] isEqualToString:@"W"])
        {
            CALayer *stoneLayer = [CALayer layer];
            stoneLayer.frame = CGRectMake(rowValueOfNewMove*stoneSize,columnValueOfNewMove*stoneSize,stoneSize,stoneSize);
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
        NSLog(@"About to redraw the board");
        CALayer *boardLayer = [CALayer layer];
        boardLayer.frame = CGRectMake(0,0,768,768);
        boardLayer.contents = (id) [UIImage imageNamed:@"Goban.png"].CGImage;
        [self.view.layer addSublayer:boardLayer];
    
        // Check the positions you need to draw at
        NSLog(@"Drawing stones");
        for(int i=0;i<[goBoard.goban count];i++)
        {
            for(int j=0;j<[goBoard.goban count];j++)
            {
                if([goBoard.goban[j][i] isEqualToString:@"B"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([goBoard.goban[j][i] isEqualToString:@"W"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"whiteStone.png"].CGImage;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else
                {
                    //NSLog(@"Draw nothing at coordinates (%d,%d)",j,i);
                }
            }
        }
        [goBoard setRedrawBoardNeeded:NO];
    }
}

- (IBAction)pressedBack:(id)sender
{
    NSLog(@"Pressed back");
    
    //restore the board to it's previous state
    [goBoard back];
    
    //If anything breaks the back button, this would be it
    [goBoard setRedrawBoardNeeded:YES];
    [self drawBoardForNewMove:0 andForColumn:0];
    //Reset the number of captured stones
    self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", goBoard.previousCapturedWhiteStones];
    self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", goBoard.previousCapturedBlackStones];

}

- (IBAction)pressedResign:(id)sender
{
    if([goBoard.turn isEqualToString:@"B"])
    {
        //Show warning
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"White Wins!" message:@"Black resigned" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Show warning
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Black Wins!" message:@"White resigned" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) startTimer {
    gameClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

//Countdown blacks timer if it is black's turn
- (void) timerCallback {
    NSMutableString *result = [[NSMutableString alloc] init];
    int iMinutes = 25;
    int iSeconds = 0;
    if([goBoard.turn isEqualToString:@"B"]) //Countdown blacks timer if it is black's turn
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
            NSLog(@"Reset iSeconds %d", iSeconds);
        }
        else
        {
            iSeconds--;
        }
        
        if(iMinutes < 0)
        {
            [gameClock invalidate];
            [self timeUp];
        }
        else
        {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds]; //%d or %i both is ok.
            self.blackRemainingTimeLabel.text = result;
            NSLog(@"Remaining time of black: %@", self.blackRemainingTimeLabel.text);
        }
    }
    else if([goBoard.turn isEqualToString:@"W"])
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
            [gameClock invalidate];
            [self timeUp];
        }
        else
        {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds]; //%d or %i both is ok.
            self.whiteRemainingTimeLabel.text = result;
            NSLog(@"Remaining time of white: %@", self.whiteRemainingTimeLabel.text);
        }
    }
    else
    {
        //Do nothing
    }
}

- (void)timeUp
{
    if([goBoard.turn isEqualToString:@"B"])
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)score
{
    NSLog(@"Called score");
}

@end
