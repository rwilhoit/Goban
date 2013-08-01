//
//  Goban.m
//  Goban
//
//  Created by Raj Wilhoit on 3/18/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "Goban.h"

@implementation Goban

@synthesize goban;
@synthesize previousStateOfBoard;
@synthesize turn;
@synthesize boardCreationDate;
@synthesize moveNumber;
@synthesize whiteStones;
@synthesize blackStones;
@synthesize capturedBlackStones;
@synthesize capturedWhiteStones;
@synthesize previousCapturedBlackStones;
@synthesize previousCapturedWhiteStones;
@synthesize komi;
@synthesize redrawBoardNeeded;
@synthesize hashValue;

-(id)init:(NSMutableArray *) goBoard
{
    if (self = [super init])
    {
        self.goban = goBoard;
    }
    return self;
}

-(id)init
{
    return [super init];
}

-(void)printBoardToConsole{
    NSMutableString *printRow = [[NSMutableString alloc] init];
    [printRow appendString:@"\n"];
    for(int i=0;i<COLUMN_LENGTH+1; i++)
    {
        for(int j=0; j<ROW_LENGTH+1; j++)
        {
            [printRow appendString:self.goban[j][i]];
            [printRow appendString:@" "];
        }
        [printRow appendString:@"\n"];
    }
    
    NSLog(@"%@", printRow);
}

-(NSString *)serializeBoard
{
    NSMutableString *board_string = [[NSMutableString alloc] init];
    for(int i=0;i<COLUMN_LENGTH+1; i++)
    {
        for(int j=0; j<ROW_LENGTH+1; j++)
        {
            [board_string appendString:self.goban[j][i]];
        }
    }
    return (NSString *)board_string;
}

-(NSMutableArray *)deserializeBoard:(NSString *)boardString
{
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
    
    return deserializedBoard;
}

-(BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue
{
    if(rowValue < 0 || rowValue > ROW_LENGTH || columnValue < 0 || columnValue > COLUMN_LENGTH)
    {
        //Stone was out of bounds
        return NO;
    }
    
    //Stone was in bounds
    return YES;
}

-(BOOL)isLegalMove:(int)rowValue andForColumnValue:(int)columnValue
{
    // Check if given move was in bounds
    if(![self isInBounds:rowValue andForColumnValue:columnValue])
    {
        NSLog(@"Illegal move: move was out of bounds");
        return NO;
    }
    // Check if the move has already been played
    if(![self.goban[rowValue][columnValue] isEqualToString:@"+"])
    {
        NSLog(@"Illegal move: Move has already been played");
        return NO;
    }
    
    // Check if space has liberties still
    BOOL hasLiberties = NO;
    // Check right for liberties
    if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    // Check left for liberties
    if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    // Check down for liberties
    if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    // Check up for liberties
    if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    // Check if any liberties were found and return NO (and print message) if they weren't
    if(!hasLiberties)
    {
        NSLog(@"Saving the state of the board");
        
        //Initialize a double array
        NSMutableArray *savedStateOfBoard = [NSMutableArray arrayWithObjects:
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

        // Saving the state of the board
        for(int i=0;i<[self.goban count];i++)
        {
            for(int j=0;j<[self.goban count];j++)
            {
                if([self.goban[j][i] isEqualToString:@"+"])
                {
                    savedStateOfBoard[j][i] = @"+";
                }
                else if([self.goban[j][i] isEqualToString:@"B"])
                {
                    savedStateOfBoard[j][i] = @"B";
                }
                else if([self.goban[j][i] isEqualToString:@"W"])
                {
                    savedStateOfBoard[j][i] = @"W";
                }
            }
        } //State of the board saved

        // Play the move and then set it back if it's not legal
        int tempWhiteCaptureCount = self.capturedWhiteStones;
        int tempBlackCaptureCount = self.capturedBlackStones;
        self.goban[rowValue][columnValue] = self.turn;
        [self checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
        [self printBoardToConsole];
        
        //Check if any adjacent stones died, once they died, check if they match the previous board and if they do, we have a ko, if they don't then we don't
        int deathRow;
        int deathColumn;
        BOOL stonesDied = NO;
        BOOL koFound = NO;
        BOOL suicide = NO;
        NSString *enemyColor = [[NSMutableString alloc] init];

        // Check if stones died to the right
        if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:@"+"])
        {
            deathRow = rowValue + 1;
            deathColumn = columnValue;
            stonesDied = YES;
        }
        // Check if stones died to the left
        else if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:@"+"])
        {
            deathRow = rowValue - 1;
            deathColumn = columnValue;
            stonesDied = YES;
        }
        // Check if stones died to the up
        else if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:@"+"])
        {
            deathRow = rowValue;
            deathColumn = columnValue + 1;
            stonesDied = YES;
        }
        // Check if stones died to the down
        else if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:@"+"])
        {
            deathRow = rowValue;
            deathColumn = columnValue - 1;
            stonesDied = YES;
        }
        else
        {
            NSLog(@"No stones died");
        }
        
        if(stonesDied)
        {
            // Get whose move it is
            if([self.turn isEqualToString:@"B"])
            {
                enemyColor = @"W";
            }
            else
            {
                enemyColor = @"B";
            }

            // Check if this new board matches the previous board
            if([self.goban isEqualToArray:self.previousStateOfBoard])
            {
                NSLog(@"Illegal Move: Ko");
                //Show warning
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ko" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                koFound = YES;
            }
            else
            {
                NSLog(@"Ko not found, checking for suicides");
            }
            
            NSLog(@"Setting the board back to its saved state");
            //Setting the board back to its saved state
            for(int i=0;i<[self.goban count];i++)
            {
                for(int j=0;j<[self.goban count];j++)
                {
                    if([savedStateOfBoard[j][i] isEqualToString:@"+"])
                    {
                        self.goban[j][i] = @"+";
                    }
                    else if([savedStateOfBoard[j][i] isEqualToString:@"B"])
                    {
                        self.goban[j][i] = @"B";
                    }
                    else if([savedStateOfBoard[j][i] isEqualToString:@"W"])
                    {
                        self.goban[j][i] = @"W";
                    }
                }
            } //Board set back to its saved state

            //Restore the number of captured stones
            [self setCapturedWhiteStones:tempWhiteCaptureCount];
            [self setCapturedBlackStones:tempBlackCaptureCount];
            NSLog(@"Board set back to previous state");
            [self printBoardToConsole];
            if(koFound)
            {
                return NO;                
            }
        }
        else
        {
            //If no stones died, check if the move was a suicide move
            //Check if the move was a suicide move
            [self checkLifeOfStone:rowValue andForColumnValue:columnValue];
            //If the space is now a + then it was a suicide
            if([self.goban[rowValue][columnValue] isEqualToString:@"+"])
            {
                suicide = YES;
            }
            
            //Set the board back to its previous state
            for(int i=0;i<[self.goban count];i++)
            {
                for(int j=0;j<[self.goban count];j++)
                {
                    if([savedStateOfBoard[j][i] isEqualToString:@"+"])
                    {
                        self.goban[j][i] = @"+";
                    }
                    else if([savedStateOfBoard[j][i] isEqualToString:@"B"])
                    {
                        self.goban[j][i] = @"B";
                    }
                    else if([savedStateOfBoard[j][i] isEqualToString:@"W"])
                    {
                        self.goban[j][i] = @"W";
                    }
                }
            } //Board set back to its saved state
            
            
            self.goban[rowValue][columnValue] = @"+";
            [self setCapturedWhiteStones:tempWhiteCaptureCount];
            [self setCapturedBlackStones:tempBlackCaptureCount];
            //NSLog(@"Set board back to its previous state");
            [self printBoardToConsole];
            
            if(suicide)
            {
                NSLog(@"Illegal move: Suicide");
                return NO;
            }
        }
    }
    
    NSLog(@"Legal move");
    return YES;
}

-(BOOL)checkIfNodeHasBeenVisited:(NSMutableArray *)visitedNodeList forRowValue:(int)rowValueToCheck andForColumnValue:(int)columnValueToCheck
{
    BOOL hasBeenVisited = NO;
    Stone *stoneInVisitedNodeList = [[Stone alloc] init];
    
    for(int i=0;i<[visitedNodeList count];i++)
    {
        stoneInVisitedNodeList = visitedNodeList[i];
        
        //Check if the coordinates match the coordinates of any nodes in the visited node queue
        if(stoneInVisitedNodeList.rowValue == rowValueToCheck && stoneInVisitedNodeList.columnValue == columnValueToCheck)
        {
            //NSLog(@"Node has been visited");
            hasBeenVisited = YES;
            break;
        }
    }
    //NSLog(@"Count of visited stones: %d", [visitedNodeList count]);
    
    return hasBeenVisited;
}

-(void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
{
    //Get my color and my opponent's color
    NSString *myColor = self.goban[rowValue][columnValue];
    NSString *opponentColor = [[NSString alloc] init];
    if([myColor isEqualToString:@"B"])
    {
        opponentColor = @"W";
        //NSLog(@"My opponent's color is %@", opponentColor);
    }
    else
    {
        opponentColor = @"B";
        //NSLog(@"My opponent's color is %@", opponentColor);
    }
    
    //Check adjacent enemy stones
    //Check right
    //NSLog(@"About to check right enemy stone where rowValue = %d and columnValue = %d", (rowValue+1), columnValue);
    if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:opponentColor])
    {
        //NSLog(@"Checking right enemy stone");
        [self checkLifeOfStone:(rowValue+1) andForColumnValue:columnValue];
    }
    else if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:@"+"])
    {
        //NSLog(@"Space to the right of stone was a free space");
    }
    else if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:myColor])
    {
        //NSLog(@"Space to the right of stone was my color");
    }
    else
    {
        //NSLog(@"Right enemy stone was out of bounds or was not an enemy");
    }
    //Check left
    //NSLog(@"About to check left enemy stone");
    if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:opponentColor])
    {
        //NSLog(@"Checking left enemy stone");
        [self checkLifeOfStone:(rowValue-1) andForColumnValue:columnValue];
    }
    else if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:@"+"])
    {
        //NSLog(@"Space to the left of stone was a free space");
    }
    else if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:myColor])
    {
        //NSLog(@"Space to the left of stone was my color");
    }
    else
    {
        //NSLog(@"Left enemy stone was out of bounds or was not an enemy");
    }
    //Check down
    //NSLog(@"About to check down enemy stone");
    if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:opponentColor])
    {
        //NSLog(@"Checking down enemy stone");
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue+1)];
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:@"+"])
    {
        //NSLog(@"Space to the down of stone was a free space");
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:myColor])
    {
        //NSLog(@"Space to the down of stone was my color");
    }
    else
    {
        //NSLog(@"Down enemy stone was out of bounds or was not an enemy");
    }
    //Check up
    //NSLog(@"About to check up enemy stone");
    if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:opponentColor])
    {
        //NSLog(@"Checking up enemy stone");
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue-1)];
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:@"+"])
    {
        //NSLog(@"Space to the up of stone was a free space");
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:myColor])
    {
        //NSLog(@"Space to the up of stone was my color");
    }
    else
    {
        //NSLog(@"Up enemy stone was out of bounds or was not an enemy");
    }
}

-(void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue
{
    //It is already implied that if we are at this point in the code, then the piece at the given location is a valid piece
    //Figure out what is an enemy color and what is an ally piece
    NSString *allyColor = [[NSString alloc] init];  //Color of ally stones
    NSString *enemyColor = [[NSString alloc] init]; //Color of enemy stones
    BOOL stonesAreDead = YES;                       //Flag for if the stones are dead or not
    allyColor = self.goban[rowValue][columnValue];  //Set the ally color to the stone we are checking
    if([allyColor isEqualToString:@"B"])
    {
        enemyColor = @"W";
    }
    else
    {
        enemyColor = @"B";
    }
    
    //BFS
    //Put the coordinates in a point and then add the point to the queue and visited nodes list
    Stone *vertex = [[Stone alloc] init];
    [vertex setColumnValue:columnValue];
    [vertex setRowValue:rowValue];
        
    //Push the root node into the queue (I don't actually think this is how you do it)
    // 1. Mark the root as visited.
    NSMutableArray *queue = [[NSMutableArray alloc] init];
    NSMutableArray *visitedNodes = [NSMutableArray arrayWithObject:vertex];
    
    NSString *goal = @"+";
    
    // 2. Check for free spaces around the root, mark all nodes of the same color as visited. Add all adjacent nodes to the root as visited
    //Check all spots around where the vertex is
    
    //Check spot to the right of vertex
    if([self isInBounds:(vertex.rowValue+1) andForColumnValue:vertex.columnValue])
    {        
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue+1][vertex.columnValue] isEqualToString:allyColor])
        {
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:vertex.rowValue+1];
            [point setColumnValue:vertex.columnValue];

            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
        }
        //If it is a free space then we're done!
        else if([self.goban[vertex.rowValue+1][vertex.columnValue] isEqualToString:goal])
        {
            //We have found a free space, so remove all objects from the queue
            [queue removeAllObjects];
            stonesAreDead = NO;
        }
        else
        {
            //If it is an ally piece, then what do we do?
        }
    }
    //Check spot to the left of the vertex
    if([self isInBounds:(vertex.rowValue-1) andForColumnValue:vertex.columnValue] && stonesAreDead)
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue-1][vertex.columnValue] isEqualToString:allyColor])
        {
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:vertex.rowValue-1];
            [point setColumnValue:vertex.columnValue];
            
            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
        }
        else if([self.goban[vertex.rowValue-1][vertex.columnValue] isEqualToString:goal])
        {
            //We have found a free space, so remove all objects from the queue
            [queue removeAllObjects];
            stonesAreDead = NO;
            //NSLog(@"Free space found to the left. Stone or stone cluster is alive (found at vertex)");
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
        }
    }
    //Check spot below the vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue+1)] && stonesAreDead)
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue][vertex.columnValue+1] isEqualToString:allyColor])
        {
            //NSLog(@"ALLY STONE TO THE DOWN AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue+1);
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:vertex.rowValue];
            [point setColumnValue:vertex.columnValue+1];
            
            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
        }
        else if([self.goban[vertex.rowValue][vertex.columnValue+1] isEqualToString:goal])
        {
            //We have found a free space, so remove all objects from the queue
            [queue removeAllObjects];
            stonesAreDead = NO;
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
        }
    }
    //Check the spot above the vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue-1)] && stonesAreDead)
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue][vertex.columnValue-1] isEqualToString:allyColor])
        {
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:vertex.rowValue];
            [point setColumnValue:vertex.columnValue-1];
            
            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
        }
        else if([self.goban[vertex.rowValue][vertex.columnValue-1] isEqualToString:goal])
        {
            //We have found a free space, so remove all objects from the queue
            [queue removeAllObjects];
            stonesAreDead = NO;
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
        }
    }
    
    //Loop until the queue is empty
    while([queue count] > 0) 
    {
        //NSLog(@"Checking nodes past the vertex (inside loop)");
        // 1. Pick the vertex at the head of the queue
        Stone *topOfQueue = queue[0];
        
        // 2. Dequeue the vertex at the head of the queue, syntax: - (void)removeObjectAtIndex:(NSUInteger)index
        [queue removeObjectAtIndex:0];
        
        // 3. Mark all unvisited vertices as visited (only if they aren't visited already!) and check for free spaces around the current node, ending if one is found.
        //Check spot to the right of vertex
        if([self isInBounds:(topOfQueue.rowValue+1) andForColumnValue:topOfQueue.columnValue] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(topOfQueue.rowValue+1) andForColumnValue:topOfQueue.columnValue])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue+1][topOfQueue.columnValue] isEqualToString:allyColor])
            {
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:topOfQueue.rowValue+1];
                [point setColumnValue:topOfQueue.columnValue];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
            }
            //If it is a free space then we're done!
            else if([self.goban[topOfQueue.rowValue+1][topOfQueue.columnValue] isEqualToString:goal])
            {
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
                //NSLog(@"Stone or stone cluster is alive");
            }
            else
            {
                //else nothing
            }
        }
        //Check spot to the left of the vertex
        if([self isInBounds:(topOfQueue.rowValue-1) andForColumnValue:topOfQueue.columnValue] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(topOfQueue.rowValue-1) andForColumnValue:topOfQueue.columnValue])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue-1][topOfQueue.columnValue] isEqualToString:allyColor])
            {
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:topOfQueue.rowValue-1];
                [point setColumnValue:topOfQueue.columnValue];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
            }
            else if([self.goban[topOfQueue.rowValue-1][topOfQueue.columnValue] isEqualToString:goal])
            {
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
                //NSLog(@"Stone or stone cluster is alive");
            }
            else
            {
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
        //Check spot below the vertex
        if([self isInBounds:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue+1)] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue+1)])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue][topOfQueue.columnValue+1] isEqualToString:allyColor])
            {
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:topOfQueue.rowValue];
                [point setColumnValue:topOfQueue.columnValue+1];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
            }
            else if([self.goban[topOfQueue.rowValue][topOfQueue.columnValue+1] isEqualToString:goal])
            {
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
            }
            else
            {
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
        //Check the spot above the vertex
        if([self isInBounds:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue-1)] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue-1)])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue][topOfQueue.columnValue-1] isEqualToString:allyColor])
            {
                //NSLog(@"ALLY STONE TO THE UP AT LOCATION (%d,%d)", topOfQueue.rowValue,topOfQueue.columnValue-1);
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:topOfQueue.rowValue];
                [point setColumnValue:topOfQueue.columnValue-1];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
            }
            else if([self.goban[topOfQueue.rowValue][topOfQueue.columnValue-1] isEqualToString:goal])
            {
                //NSLog(@"FREE SPACE TO THE UP AT LOCATION (%d,%d)", topOfQueue.rowValue,topOfQueue.columnValue-1);
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
                //NSLog(@"Stone or stone cluster is alive");
            }
            else
            {
                //NSLog(@"MOST LIKELY AN ENEMY TO THE UP AT LOCATION (%d,%d)", topOfQueue.rowValue,topOfQueue.columnValue-1);
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
    } //End while loop
    
    //If stones are dead, set them back to unplayed spots
    if(stonesAreDead)
    {
        //NSLog(@"Killing stones (should not be called after stones are determined to be alive)");
        [self printBoardToConsole];
        [self killStones:visitedNodes];
    }
}

-(void)killStones:(NSMutableArray *)stonesToKill
{
    Stone *stone = [[Stone alloc] init];

    //Check what color the stone in the 0th index is to get the color of the stone
    stone = stonesToKill[0];
    
    //Get the color of the stones that are dying
    NSString *dyingColor = self.goban[stone.rowValue][stone.columnValue];
    if([dyingColor isEqualToString:@"B"])
    {
        //NSLog(@"Old number of captured black stones: %d", self.capturedBlackStones);
        //Add the number of dead stones to black's captured stone count
        [self setPreviousCapturedBlackStones:self.capturedBlackStones];
        [self setCapturedBlackStones:(self.capturedBlackStones + [stonesToKill count])];
        //NSLog(@"New number of captured black stones: %d", self.capturedBlackStones);
    }
    else
    {
        //Add the number of dead stones to white's dead stone count
        //NSLog(@"Old number of captured white stones: %d", self.capturedWhiteStones);
        //Add the number of dead stones to white's captured stone count
        [self setPreviousCapturedWhiteStones:self.capturedWhiteStones];
        [self setCapturedWhiteStones:(self.capturedWhiteStones + [stonesToKill count])];
        //NSLog(@"New number of captured white stones: %d", self.capturedWhiteStones);
    }
        
    //This takes the nodes from the visited Nodes array and sets them back to "+"
    for(int i=0;i<[stonesToKill count]; i++)
    {
        stone = stonesToKill[i];
        self.goban[stone.rowValue][stone.columnValue] = @"+";
        //NSLog(@"KILLING STONE at row %d and column %d", stone.rowValue, stone.columnValue);
    }
    NSLog(@"Killed stones");
    [self printBoardToConsole];
    NSLog(@"Board needs to be redrawn");
    [self setRedrawBoardNeeded:YES];
}

-(void)back
{
    //restore the board to it's previous state
    for(int i=0;i<[self.goban count];i++)
    {
        for(int j=0;j<[self.goban count];j++)
        {
            if([self.previousStateOfBoard[j][i] isEqualToString:@"+"])
            {
                self.goban[j][i] = @"+";
            }
            else if([self.previousStateOfBoard[j][i] isEqualToString:@"B"])
            {
                self.goban[j][i] = @"B";
            }
            else if([self.previousStateOfBoard[j][i] isEqualToString:@"W"])
            {
                self.goban[j][i] = @"W";
            }
        }
    }
    
    //Put the turn back also
    if([self.turn isEqualToString:@"B"])
    {
        NSLog(@"Set to white's turn: %@", self.turn);
        self.turn = @"W";
        //isBlacksTurn = NO;
    }
    else
    {
        self.turn = @"B";
        NSLog(@"Set to black's turn: %@", self.turn);
        //isBlacksTurn = YES;
    }
    
    //Put the move count back also
    if(self.moveNumber > 0)
    {
        [self setMoveNumber:(self.moveNumber-1)];
    }
    
    [self printBoardToConsole];

}

-(void)markStoneClusterAsDeadFor:(int)rowValue andForColumnValue:(int)columnValue andForColor:(NSString*)color;
{
    NSLog(@"Called markStonesAsDead");
    
    //BFS
    //Put the coordinates in a point and then add the point to the queue and visited nodes list
    Stone *vertex = [[Stone alloc] init];
    [vertex setColumnValue:columnValue];
    [vertex setRowValue:rowValue];
    
    // 1. Mark the root as visited.
    NSMutableArray *queue = [[NSMutableArray alloc] init];
    NSMutableArray *visitedNodes = [NSMutableArray arrayWithObject:vertex];
    if([color isEqualToString:@"B"])
    {
        self.goban[vertex.rowValue][vertex.columnValue] = @"b";
    }
    else if([color isEqualToString:@"W"])
    {
        self.goban[vertex.rowValue][vertex.columnValue] = @"w";
    }
    else
    {
        //Else nothing
    }
    
    // 2. Check for free spaces around the root, mark all nodes of the same color as visited. Add all adjacent nodes to the root as visited
    //Check all spots around where the vertex is
    
    //Check spot to the right of vertex
    if([self isInBounds:(vertex.rowValue+1) andForColumnValue:vertex.columnValue])
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue+1][vertex.columnValue] isEqualToString:color])
        {
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:(vertex.rowValue+1)];
            [point setColumnValue:vertex.columnValue];
            
            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
            
            //Change the spot on the board to lowercase
            if([color isEqualToString:@"B"])
            {
                self.goban[vertex.rowValue+1][vertex.columnValue] = @"b";
            }
            else if([color isEqualToString:@"W"])
            {
                self.goban[vertex.rowValue+1][vertex.columnValue] = @"w";
            }
            else
            {
                //else nothing
            }
        }
        else
        {
            //else nothing
        }
    }
    //Check spot to the left of the vertex
    if([self isInBounds:(vertex.rowValue-1) andForColumnValue:vertex.columnValue])
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue-1][vertex.columnValue] isEqualToString:color])
        {
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:(vertex.rowValue-1)];
            [point setColumnValue:vertex.columnValue];
            
            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
            
            //Change the spot on the board to lowercase
            if([color isEqualToString:@"B"])
            {
                self.goban[vertex.rowValue-1][vertex.columnValue] = @"b";
            }
            else if([color isEqualToString:@"W"])
            {
                self.goban[vertex.rowValue-1][vertex.columnValue] = @"w";
            }
            else
            {
                //else nothing
            }
        }
        else
        {
            //else nothing
        }
    }
    //Check spot to the up of vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue-1)])
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue][vertex.columnValue-1] isEqualToString:color])
        {
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:vertex.rowValue];
            [point setColumnValue:vertex.columnValue-1];
            
            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
            
            //Change the spot on the board to lowercase
            if([color isEqualToString:@"B"])
            {
                self.goban[vertex.rowValue][vertex.columnValue-1] = @"b";
            }
            else if([color isEqualToString:@"W"])
            {
                self.goban[vertex.rowValue][vertex.columnValue-1] = @"w";
            }
            else
            {
                //else nothing
            }
        }
        else
        {
            //else nothing
        }
    }
    //Check spot to the down of vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue+1)])
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue][vertex.columnValue+1] isEqualToString:color])
        {
            //Create a new point and insert it into the queue
            Stone *point = [[Stone alloc] init];
            [point setRowValue:vertex.rowValue];
            [point setColumnValue:(vertex.columnValue+1)];
            
            //Mark the object as visited and insert it to the end of the visited queue
            [visitedNodes addObject:point];
            //Insert the object into the end of the queue
            [queue addObject:point];
            
            //Change the spot on the board to lowercase
            if([color isEqualToString:@"B"])
            {
                self.goban[vertex.rowValue][vertex.columnValue+1] = @"b";
            }
            else if([color isEqualToString:@"W"])
            {
                self.goban[vertex.rowValue][vertex.columnValue+1] = @"w";
            }
            else
            {
                //else nothing
            }
        }
        else
        {
            //else nothing
        }
    }
    
    //Check if node has been visited is what is broken
    
    //Loop until the queue is empty
    while([queue count] > 0)
    {
        // 1. Pick the vertex at the head of the queue
        Stone *topOfQueue = queue[0];
        
        // 2. Dequeue the vertex at the head of the queue, syntax: - (void)removeObjectAtIndex:(NSUInteger)index
        [queue removeObjectAtIndex:0];
        
        // 3. Mark all unvisited vertices as visited (only if they aren't visited already!)
        //Check spot to the right of vertex
        if([self isInBounds:(topOfQueue.rowValue+1) andForColumnValue:topOfQueue.columnValue] && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(topOfQueue.rowValue+1) andForColumnValue:topOfQueue.columnValue])
        {
            //Change it's letter to lower case, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue+1][topOfQueue.columnValue] isEqualToString:color])
            {
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:(topOfQueue.rowValue+1)];
                [point setColumnValue:topOfQueue.columnValue];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
                
                //Change the spot on the board to lowercase
                if([color isEqualToString:@"B"])
                {
                    self.goban[topOfQueue.rowValue+1][topOfQueue.columnValue] = @"b";
                }
                else if([color isEqualToString:@"W"])
                {
                    self.goban[topOfQueue.rowValue+1][topOfQueue.columnValue] = @"w";
                }
                else
                {
                    //else nothing
                }
            }
            else
            {
                //Else nothing
            }
        }
        //Check spot to the left of the vertex
        if([self isInBounds:(topOfQueue.rowValue-1) andForColumnValue:topOfQueue.columnValue] && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(topOfQueue.rowValue-1) andForColumnValue:topOfQueue.columnValue])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue-1][topOfQueue.columnValue] isEqualToString:color])
            {
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:(topOfQueue.rowValue-1)];
                [point setColumnValue:topOfQueue.columnValue];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
                
                //Change the spot on the board to lowercase
                if([color isEqualToString:@"B"])
                {
                    self.goban[topOfQueue.rowValue-1][topOfQueue.columnValue] = @"b";
                }
                else if([color isEqualToString:@"W"])
                {
                    self.goban[topOfQueue.rowValue-1][topOfQueue.columnValue] = @"w";
                }
                else
                {
                    //Else nothing
                }
            }
            else
            {
                //Else nothing
            }
        }
        //Check spot below the vertex
        if([self isInBounds:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue+1)] && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue+1)])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue][topOfQueue.columnValue+1] isEqualToString:color])
            {
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:topOfQueue.rowValue];
                [point setColumnValue:topOfQueue.columnValue+1];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
                
                //Change the spot on the board to lowercase
                if([color isEqualToString:@"B"])
                {
                    self.goban[topOfQueue.rowValue][topOfQueue.columnValue+1] = @"b";
                }
                else if([color isEqualToString:@"W"])
                {
                    self.goban[topOfQueue.rowValue][topOfQueue.columnValue+1] = @"w";
                }
                else
                {
                    //else nothing
                }
            }
            else
            {
                //Else nothing
            }
        }
        //Check the spot above the vertex
        if([self isInBounds:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue-1)] && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:topOfQueue.rowValue andForColumnValue:(topOfQueue.columnValue-1)])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[topOfQueue.rowValue][topOfQueue.columnValue-1] isEqualToString:color])
            {
                //Create a new point and insert it into the queue
                Stone *point = [[Stone alloc] init];
                [point setRowValue:topOfQueue.rowValue];
                [point setColumnValue:topOfQueue.columnValue-1];
                
                //Mark the object as visited and insert it to the end of the visited queue
                [visitedNodes addObject:point];
                //Insert the object into the end of the queue
                [queue addObject:point];
                
                //Change the spot on the board to lowercase
                if([color isEqualToString:@"B"])
                {
                    self.goban[topOfQueue.rowValue][topOfQueue.columnValue-1] = @"b";
                }
                else if([color isEqualToString:@"W"])
                {
                    self.goban[topOfQueue.rowValue][topOfQueue.columnValue-1] = @"w";
                }
                else
                {
                    //else nothing
                }
            }
            else
            {
                //else nothing
            }
        }
    } //End while loop
    
    //Set that the board needs to be redrawn
    [self setRedrawBoardNeeded:YES];
}

@end