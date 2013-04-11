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

- (void)viewDidLoad
{
    // Add the main view image
    self.view.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.view.layer.cornerRadius = 20.0;
    self.view.layer.frame = CGRectInset(self.view.layer.frame, 20, 20);
    
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
    isBlacksTurn = YES;
    [goBoard setTurn:@"B"];
    
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
            // Draw a red circle where the touch occurred
        //UIView *touchView = [[UIView alloc] init];
        //[touchView setBackgroundColor:[UIColor redColor]];
        //touchView.frame = CGRectMake(touchPoint.x, touchPoint.y, 30, 30);
        //touchView.layer.cornerRadius = 15;
        //[self.view addSubview:touchView];
        //[touchView release];
        //Get specific coordinates from touch event
        rowValue = (int)floor(touchPoint.x/40.4210526316);
        columnValue = (int)floor(touchPoint.y/40.4210526316);

    }];
    
    //Need to set the lastMove somewhere and the new current move somewhere 
    
    NSLog(@"Row coordingate: %d", rowValue);
    NSLog(@"Columns coordinate: %d", columnValue);
    
    //Check if new move is legal
    if([goBoard isLegalMove:rowValue andForColumnValue:columnValue])
    {
        if(isBlacksTurn)
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
            [self drawBoard];
            
            //Set to white's turn
            NSLog(@"Set to white's turn");
            isBlacksTurn = NO;
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
            
            //Draw the entire board again
            [self drawBoard];
            
            //Set to black's turn
            NSLog(@"Set to black's turn");
            isBlacksTurn = YES;
            [goBoard setTurn:@"B"];
        }
    }
    
    //Print results
    [goBoard printBoardToConsole];
     
}

- (void)drawBoard
{
    NSLog(@"About to redraw the board");
    float stoneSize = 40.4210526316;
    NSLog(@"Stone size: %f", stoneSize);
    CALayer *boardLayer = [CALayer layer];
    boardLayer.backgroundColor = [UIColor blackColor].CGColor;
    //sublayer.frame = CGRectMake(self.view.layer.bounds.origin.x,self.view.layer.bounds.origin.y,self.view.layer.bounds.size.width, self.view.layer.bounds.size.height);
    boardLayer.frame = CGRectMake(0,0,768,768);
    boardLayer.contents = (id) [UIImage imageNamed:@"Goban.png"].CGImage;
    [self.view.layer addSublayer:boardLayer];
    
    // Check the positions you need to draw at
    NSLog(@"Moves have been played at: ");
    for(int i=0;i<[goBoard.goban count];i++)
    {
        for(int j=0;j<[goBoard.goban count];j++)
        {
            if([goBoard.goban[j][i] isEqualToString:@"B"])
            {
                NSLog(@"Draw a black stone at coordinates (%d,%d) and location (%f,%f)",j,i,j*stoneSize,i*stoneSize);
                //Code to draw a black stone
                
                CALayer *stoneLayer = [CALayer layer];
                stoneLayer.backgroundColor = [UIColor blackColor].CGColor;
                stoneLayer.frame = CGRectMake(j*stoneSize,i*stoneSize,stoneSize,stoneSize);
                stoneLayer.contents = (id) [UIImage imageNamed:@"blackStone.png"].CGImage;
                [self.view.layer addSublayer:stoneLayer];
            }
            else if([goBoard.goban[j][i] isEqualToString:@"W"])
            {
                NSLog(@"Draw a white stone at coordinates (%d,%d) and location (%f,%f)",j,i,j*stoneSize,i*stoneSize);
                //Code to draw a white stone
                CALayer *stoneLayer = [CALayer layer];
                stoneLayer.backgroundColor = [UIColor blackColor].CGColor;
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
}

- (IBAction)pressedBack:(id)sender
{
    NSLog(@"Pressed back");
    
    //restore the board to it's previous state
    for(int i=0;i<[goBoard.goban count];i++)
    {
        for(int j=0;j<[goBoard.goban count];j++)
        {
            if([goBoard.previousStateOfBoard[j][i] isEqualToString:@"+"])
            {
                goBoard.goban[j][i] = @"+";
            }
            else if([goBoard.previousStateOfBoard[j][i] isEqualToString:@"B"])
            {
                goBoard.goban[j][i] = @"B";
            }
            else if([goBoard.previousStateOfBoard[j][i] isEqualToString:@"W"])
            {
                goBoard.goban[j][i] = @"W";
            }
        }
    }
    
    //Put the turn back also
    if([goBoard.turn isEqualToString:@"B"])
    {
        NSLog(@"Set to white's turn: %@", goBoard.turn);
        goBoard.turn = @"W";
        isBlacksTurn = NO;
    }
    else
    {
        goBoard.turn = @"B";
        NSLog(@"Set to black's turn: %@", goBoard.turn);
        isBlacksTurn = YES;
    }
    
    //Put the move count back also
    if(goBoard.moveNumber > 0)
    {
        [goBoard setMoveNumber:(goBoard.moveNumber-1)];
    }
    
    [goBoard printBoardToConsole];
    [self drawBoard];
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
