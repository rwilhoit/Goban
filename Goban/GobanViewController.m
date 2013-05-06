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

@synthesize mainMenuButton;
@synthesize resignButton;
@synthesize whiteCapturedStoneCountLabel;
@synthesize whiteCapturedStonesStaticLabel;
@synthesize blackCapturedStoneCountLabel;
@synthesize blackCapturedStonesStaticLabel;
@synthesize whiteRemainingTimeLabel;
@synthesize whiteRemainingTimeStaticLabel;
@synthesize blackRemainingTimeLabel;
@synthesize blackRemainingTimeStaticLabel;
@synthesize boardLoadRequest;
@synthesize responseData;
@synthesize serverId;
@synthesize currentlyMarkingStonesAsDead;
@synthesize currentlyScoringGame;

//Go board declared as a global variable
Goban *goBoard;
NSTimer *gameClock;

- (void)viewDidLoad
{    
    //Initialize the response data variable
    self.responseData = [[NSMutableData alloc] init];

    // Add the main view image
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.frame = CGRectMake(0,0,768,768);
    sublayer.contents = (id) [UIImage imageNamed:@"Goban.png"].CGImage;
    [self.view.layer addSublayer:sublayer];
        
    // Draw the buttons
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [mainMenuButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [mainMenuButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [resignButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [resignButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    //Set the color of the buttons
    self.blackCapturedStonesStaticLabel.textColor = [UIColor orangeColor];
    self.whiteCapturedStonesStaticLabel.textColor = [UIColor orangeColor];
    self.blackCapturedStoneCountLabel.textColor = [UIColor orangeColor];
    self.whiteCapturedStoneCountLabel.textColor = [UIColor orangeColor];
    self.whiteRemainingTimeLabel.textColor = [UIColor orangeColor];
    self.whiteRemainingTimeStaticLabel.textColor = [UIColor orangeColor];
    self.blackRemainingTimeLabel.textColor = [UIColor orangeColor];
    self.blackRemainingTimeStaticLabel.textColor = [UIColor orangeColor];
    self.view.backgroundColor = [UIColor blackColor];
    [self.blackRemainingTimeLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.blackRemainingTimeStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteRemainingTimeLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteRemainingTimeStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteCapturedStoneCountLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.whiteCapturedStonesStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.blackCapturedStoneCountLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.blackCapturedStonesStaticLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    
    //Initialize the goBoard and populate it
    goBoard = [[Goban alloc] init];

    //check if board load is needed
    if(boardLoadRequest)
    {
        //Load board
        NSLog(@"Board load request set successfully");
        
        //Set redraw needed
        [goBoard setRedrawBoardNeeded:YES];
    }
    else
    {
        NSLog(@"Initializing new board");
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

        //Set the number of captured white stones
        [goBoard setCapturedWhiteStones:0];
        
        //Set the number of captured black stones
        [goBoard setCapturedBlackStones:0];
        
        //Set redraw needed
        [goBoard setRedrawBoardNeeded:NO];
    }
    
        //Set the moveNumber
        [goBoard setMoveNumber:0];
    
        //Set the number of white stones
        [goBoard setWhiteStones:0];
    
        //Set the number of black stones
        [goBoard setBlackStones:0];
    
        //Set the komi count to a default (for now) of 6.5
        [goBoard setKomi:6.5];

        //Set both pass variables to false
        [goBoard setWhitePassed:NO];
        [goBoard setBlackPassed:NO];
    
        //Set currently scoring game to NO
        [self setCurrentlyScoringGame:NO];
    
        //Set it to black's turn
        [goBoard setTurn:@"B"];
    
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

    //Check if we are marking stones as dead
    if(self.currentlyMarkingStonesAsDead && [goBoard isInBounds:rowValue andForColumnValue:columnValue])
    {
        NSLog(@"Marking stone as dead");
        if([goBoard.goban[rowValue][columnValue] isEqualToString:@"B"])
        {
            [goBoard markStoneClusterAsDeadFor:rowValue andForColumnValue:columnValue andForColor:@"B"];
            [self drawBoardForNewMove:0 andForColumn:0];
        }
        else if([goBoard.goban[rowValue][columnValue] isEqualToString:@"W"])
        {
            [goBoard markStoneClusterAsDeadFor:rowValue andForColumnValue:columnValue andForColor:@"W"];
            [self drawBoardForNewMove:0 andForColumn:0];
        }
        else
        {
            //else nothing
        }
    }
    else if([goBoard isLegalMove:rowValue andForColumnValue:columnValue]) //Check if new move is legal
    {
        if([goBoard.turn isEqualToString:@"B"])
        {
            //Save the previous state of the board
            goBoard.previousStateOfBoard = [[NSMutableArray alloc] initWithArray:goBoard.goban copyItems:YES];
            
            //Play black's turn
            goBoard.goban[rowValue][columnValue] = @"B";
            
            if([goBoard.previousStateOfBoard[rowValue][columnValue] isEqualToString:goBoard.goban[rowValue][columnValue]])
            {
                //NSLog(@"PREVIOUS STATE OF THE BOARD DID NOT SAVE");
            }
            else
            {
                //NSLog(@"PREVIOUS STATE OF THE BOARD SUCCESSFULLY SAVED: PREVIOUS WAS %@ AND NOW IS %@", goBoard.previousStateOfBoard[rowValue][columnValue], goBoard.goban[rowValue][columnValue]);
            }
            
            //Increment the move number
            [goBoard setMoveNumber:(goBoard.moveNumber+1)];
            
            //Check the life of adjacent pieces of the opposite color
            [goBoard checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
            
            //Draw the entire board again
            [self drawBoardForNewMove:rowValue andForColumn:columnValue];
            
            //Update the captured stone count
            self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", goBoard.capturedWhiteStones];
            
            //Save to server
            [self saveBoardToServer];
            
            //Set the pass variables to NO
            [goBoard setBlackPassed:NO];
            [goBoard setWhitePassed:NO];
            
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
                //NSLog(@"PREVIOUS STATE OF THE BOARD DID NOT SAVE");
            }
            else
            {
                //NSLog(@"PREVIOUS STATE OF THE BOARD SUCCESSFULLY SAVED: PREVIOUS WAS %@ AND NOW IS %@", goBoard.previousStateOfBoard[rowValue][columnValue], goBoard.goban[rowValue][columnValue]);
            }
            
            //Check the life of adjacent pieces of the opposite color
            [goBoard checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
            
            //Increment the move number
            [goBoard setMoveNumber:(goBoard.moveNumber+1)];
            
            //Draw the entire board again, or just the new move
            [self drawBoardForNewMove:rowValue andForColumn:columnValue];
            
            //Update the captured stone count
            self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%d", goBoard.capturedBlackStones];
            
            //Save to server
            [self saveBoardToServer];
            
            //Set the pass variables to NO
            [goBoard setBlackPassed:NO];
            [goBoard setWhitePassed:NO];
            
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
                else if([goBoard.goban[j][i] isEqualToString:@"w"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"whiteStone.png"].CGImage;
                    stoneLayer.opacity = 0.5;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([goBoard.goban[j][i] isEqualToString:@"b"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize,stoneSize,stoneSize);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
                    stoneLayer.opacity = 0.5;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([goBoard.goban[j][i] isEqualToString:@"Wp"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize+stoneSize/4,i*stoneSize+stoneSize/4,stoneSize/2,stoneSize/2);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"whiteStone.png"].CGImage;
                    [self.view.layer addSublayer:stoneLayer];
                }
                else if([goBoard.goban[j][i] isEqualToString:@"Bp"])
                {
                    CALayer *stoneLayer = [CALayer layer];
                    stoneLayer.frame = CGRectMake(j*stoneSize+stoneSize/4,i*stoneSize+stoneSize/4,stoneSize/2,stoneSize/2);
                    stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
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

- (IBAction)pressedPass:(id)sender
{
    //Get the current turn and set the pass variable to true then switch the turn
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
    }
}

- (void) startTimer
{
    gameClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

//Countdown blacks timer if it is black's turn
- (void) timerCallback
{
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
            //NSLog(@"Reset iSeconds %d", iSeconds);
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
            //NSLog(@"Remaining time of black: %@", self.blackRemainingTimeLabel.text);
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

//Loading from the server
- (void)loadBoardFromServer
{
    //NSString *server_prefix = @"localhost:3000";
    NSString *server_prefix = @"goban-server.herokuapp.com";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"id.txt"];
    NSString *saved_server_id = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSLog(@"Saved server ID is %@", saved_server_id);
    
    if (saved_server_id) {
        // Url for the request
        NSString *reqURL = [NSString stringWithFormat:@"http://%@/games/%@", server_prefix, saved_server_id];
        // Since we already have the id, this is an update call
        // So the GET http method is used
        NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURL]];
        [request setHTTPMethod:@"GET"];
        NSLog(@"%@",request.HTTPBody);
        // Set the right headers so the server doesn't choke
        //[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Make the request, using this object as the delegate
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        //Get the board down from the server
    }
}


//Saving to server
-(void)saveBoardToServer
{
    // Use localhost for debugging with a local server
    // Use the heroku url for production
    //NSString *server_prefix = @"localhost:3000";
    NSString *server_prefix = @"goban-server.herokuapp.com";
    
    if (serverId)
    {
        // Url for the request
        NSString *reqURL = [NSString stringWithFormat:@"http://%@/games/%@", server_prefix, serverId];
        
        // Since we already have the id, this is an update call
        // So the PUT http method is used
        NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURL]];
        [request setHTTPMethod:@"PUT"];
        
        // Serialize the board into a string, replacing the +'s since it causes errors server side
        NSString *postString = [[NSString stringWithFormat:@"board_string=%@&black_captures=%@&white_captures=%@&black_time=%@&white_time=%@", [goBoard serializeBoard], self.blackCapturedStoneCountLabel.text, self.whiteCapturedStoneCountLabel.text, self.blackRemainingTimeLabel.text, self.whiteRemainingTimeLabel.text] stringByReplacingOccurrencesOfString:@"+" withString:@"0"];
        
        // Set the right headers so the server doesn't choke
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Make the request, using this object as the delegate
        [[NSURLConnection alloc] initWithRequest:request delegate:goBoard];
        
        /*
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *documentsDirectory = [paths objectAtIndex:0];
         NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"id.txt"];
         NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
         
         NSLog(@"%@", str);
         */
        
    }
    else
    {
        // Url for the request
        NSString *reqURL = [NSString stringWithFormat:@"http://%@/games", server_prefix];
        
        // We're making a new game on the server, so it's an http POST
        NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURL]];
        [request setHTTPMethod:@"POST"];
        
        // Serialize the board and set it in the request body
        NSString *postString = [[NSString stringWithFormat:@"board_string=%@", [goBoard serializeBoard]] stringByReplacingOccurrencesOfString:@"+" withString:@"0"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Make the request
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Show error
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection callback");
    // Once this method is invoked, "responseData" contains the complete result
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
    NSString *response_id = (NSString*)[json objectForKey:@"_id"];
    if (response_id)
    {
        serverId = (NSString*)[json objectForKey:@"_id"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
        NSError *error;
        BOOL succeed = [serverId writeToFile:[documentsDirectory stringByAppendingPathComponent:@"id.txt"]
                                  atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!succeed)
        {
            NSLog(@"Connection error");
            //Consider setting board to NOT load
        }
        
        NSLog(@"ID saved");
        
        NSString *req_is_show = (NSString*)[json objectForKey:@"req_is_show"];
        if(req_is_show)
        {
            NSLog(@"In show callback");
            //Code for loading from the dictionary here
            NSLog(@"Size of the dictionary is: %d", [json count]);

            NSLog(@"%@",[json objectForKey:@"board_string"]);
            NSString *boardString = [[json objectForKey:@"board_string"] stringByReplacingOccurrencesOfString:@"0" withString:@"+"];
            NSMutableArray *deserializedBoard = [NSMutableArray arrayWithObjects:
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

            int counter = 0;
            for(int i=0;i<[deserializedBoard count]; i++)
            {
                for(int j=0;j<[deserializedBoard[i] count]; j++)
                {
                    if([[NSString stringWithFormat:@"%C", [boardString characterAtIndex:counter]] isEqualToString:@"+"])
                    {
                        //Do nothing
                    }
                    else
                    {
                        if([[NSString stringWithFormat:@"%C", [boardString characterAtIndex:counter]] isEqualToString:@"B"])
                        {
                            deserializedBoard[j][i] = @"B";
                        }
                        else if([[NSString stringWithFormat:@"%C", [boardString characterAtIndex:counter]] isEqualToString:@"W"])
                        {
                            deserializedBoard[j][i] = @"W";
                        }
                        else
                        {
                            //else nothing
                        }
                    }
                    counter++;
                }
            }
            
            //Set the board
            [goBoard setGoban:deserializedBoard];
            [goBoard printBoardToConsole];
            //Setting the blackCaptures
            self.blackCapturedStoneCountLabel.text = [json objectForKey:@"black_captures"];
            //Setting the white captures
            self.whiteCapturedStoneCountLabel.text = [json objectForKey:@"white_captures"];
            //Setting the black time
            self.blackRemainingTimeLabel.text = [json objectForKey:@"black_time"];
            //Setting the white time
            self.whiteRemainingTimeLabel.text = [json objectForKey:@"white_time"];
            //Set that we need to load the board
            boardLoadRequest = YES;
            NSLog(@"Board loaded from server");
            [self drawBoardForNewMove:0 andForColumn:0];
        }
    }
}

-(void)scoreGame
{
    NSLog(@"Called scoreGame");
    int points = 0;
    NSMutableArray *emptySpaces = [[NSMutableArray alloc] init];
    NSString *addingPointsFor = [[NSMutableString alloc] init];
    
    for(int i=0;i<COLUMN_LENGTH+1; i++)
    {
        for(int j=0; j<ROW_LENGTH+1; j++)
        {
            if([goBoard.goban[j][i] isEqualToString:@"+"] || [goBoard.goban[j][i] isEqualToString:@"w"] || [goBoard.goban[j][i] isEqualToString:@"b"])
            {
                if([addingPointsFor isEqualToString:@"B"])
                {
                    //Mark the locations to draw half-stones
                    goBoard.goban[j][i] = @"Bp";                    
                    [goBoard setBlackStones:(goBoard.blackStones+1)];
                }
                else if([addingPointsFor isEqualToString:@"W"])
                {
                    //Just draw a half-stone for white at this position
                    goBoard.goban[j][i] = @"Wp";
                    [goBoard setWhiteStones:(goBoard.whiteStones+1)];
                }
                else
                {
                    Stone *emptySpace = [[Stone alloc] init];
                    emptySpace.rowValue = j;
                    emptySpace.columnValue = i;
                    [emptySpaces addObject:emptySpace];
                    points++;
                }
            }
            else if([goBoard.goban[j][i] isEqualToString:@"B"])
            {
                //Marking any free spaces as black's points
                if(points > 0)
                {
                    for(int i=0;i<[emptySpaces count];i++)
                    {
                        Stone *emptySpace = emptySpaces[0];
                        [emptySpaces removeObjectAtIndex:0];
                        goBoard.goban[emptySpace.rowValue][emptySpace.columnValue] = @"Bp";
                    }
                }
                addingPointsFor = @"B";
                [goBoard setBlackStones:(goBoard.blackStones+points+1)];
                points = 0;
            }
            else if([goBoard.goban[j][i] isEqualToString:@"W"])
            {
                //Marking any free spaces as white's points
                if(points > 0)
                {
                    for(int i=0;i<[emptySpaces count];i++)
                    {
                        Stone *topOfQueue = emptySpaces[0];
                        [emptySpaces removeObjectAtIndex:0];
                        goBoard.goban[topOfQueue.rowValue][topOfQueue.columnValue] = @"Wp";
                    }
                }
                addingPointsFor = @"W";
                [goBoard setWhiteStones:(goBoard.whiteStones+points+1)];
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
    [goBoard setRedrawBoardNeeded:YES];
    [self drawBoardForNewMove:0 andForColumn:0];

    //Convert both to floats and add the komi value to white
    int blackScore = (double)goBoard.blackStones + (double)goBoard.capturedWhiteStones;
    double whiteScore = (double)goBoard.whiteStones + (double)goBoard.capturedBlackStones + goBoard.komi;
    
    NSString *pointTally = [NSString stringWithFormat:@"Black: %d points + %d captures = %d\nWhite: %d points + %d captures = %.1f",goBoard.blackStones, goBoard.capturedWhiteStones, blackScore, goBoard.whiteStones, goBoard.capturedBlackStones, whiteScore];
   
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
