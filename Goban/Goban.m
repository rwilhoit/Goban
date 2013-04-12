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
@synthesize moveNumber;
@synthesize whiteStones;
@synthesize blackStones;
@synthesize capturedBlackStones;
@synthesize capturedWhiteStones;
@synthesize komi;

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

-(BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue
{
    NSLog(@"From within isInBounds...");
    NSLog(@"rowValue = %d and columnValue = %d", rowValue, columnValue);
    NSLog(@"ROW_LENGTH = %d and COLUMN_LENGTH = %d", ROW_LENGTH, COLUMN_LENGTH);
    if(rowValue < 0 || rowValue > ROW_LENGTH || columnValue < 0 || columnValue > COLUMN_LENGTH)
    {
        NSLog(@"(From within isInBounds) Stone was out of bounds");
        return NO;
    }
    
    NSLog(@"(From within isInBounds) Stone was in bounds");
    return YES;
}

-(BOOL)isLegalMove:(int)rowValue andForColumnValue:(int)columnValue
{
    NSLog(@"Row coordingate: %d", rowValue);
    NSLog(@"Columns coordinate: %d", columnValue);

    if(![self isInBounds:rowValue andForColumnValue:columnValue])
    {
        NSLog(@"Illegal move: move was out of bounds");
        return NO;
    }
    //Check if the move has already been played
    if(![self.goban[rowValue][columnValue] isEqualToString:@"+"])
    {
        NSLog(@"Illegal move: Move has already been played");
        return NO;
    }
    
    //Check if space has liberties still
    BOOL hasLiberties = NO;
    //Check right for liberties
    if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    //Check left for liberties
    if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    //Check down for liberties
    if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    //Check up for liberties
    if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:@"+"] && !hasLiberties)
    {
        hasLiberties = YES;
    }
    //Check if any liberties were found and return NO and print a log statement if they weren't
    if(!hasLiberties)
    {
        //This checks just if any of the pieces around the piece are of an ally color
        if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:self.turn])
        {
            //Maybe need to check if this could be adding a stone to the last place in a cluster which would kill the entire cluster
            NSLog(@"Legal move");
            return YES;
        }
        else if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:self.turn])
        {
            //Maybe need to check if this could be adding a stone to the last place in a cluster which would kill the entire cluster
            NSLog(@"Legal move");
            return YES;
        }
        else if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:self.turn])
        {
            //Maybe need to check if this could be adding a stone to the last place in a cluster which would kill the entire cluster
            NSLog(@"Legal move");
            return YES;
        }
        else if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:self.turn])
        {
            //Maybe need to check if this could be adding a stone to the last place in a cluster which would kill the entire cluster
            NSLog(@"Legal move");
            return YES;
        }
        else
        {
            //else nothing
        }
         
        //Just play the move and then set it back after you know if it's legal or not
        int tempWhiteCaptureCount = self.capturedWhiteStones;
        int tempBlackCaptureCount = self.capturedBlackStones;
        self.goban[rowValue][columnValue] = self.turn;
        [self checkLifeOfAdjacentEnemyStones:rowValue andForColumnValue:columnValue];
        NSLog(@"THIS IS WHERE THE BOARD GOES CRAZY");
        [self printBoardToConsole];
        
        //Check if any adjacent stones died, once they died, check if they match the previous board and if they do we have a ko, if they don't then we don't
        int deathRow;
        int deathColumn;
        BOOL stonesDied = NO;
        BOOL koFound = NO;
        NSString *enemyColor = [[NSMutableString alloc] init];

        if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:@"+"])
        {
            deathRow = rowValue + 1;
            deathColumn = columnValue;
            stonesDied = YES;
        }
        else if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:@"+"])
        {
            deathRow = rowValue - 1;
            deathColumn = columnValue;
            stonesDied = YES;
        }
        else if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:@"+"])
        {
            deathRow = rowValue;
            deathColumn = columnValue + 1;
            stonesDied = YES;
        }
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
            //Check if any adjacent stones died, once they died, check if they match the previous board and if they do we have a ko, if they don't then we don't
            //Set it back
            if([self.turn isEqualToString:@"B"])
            {
                enemyColor = @"W";
            }
            else
            {
                enemyColor = @"B";
            }
            //check if this new board matches the previous board
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
                NSLog(@"Ko not found");
            }
            
            NSLog(@"It is %@'s turn so the enemy color is %@", self.turn, enemyColor);
            self.goban[deathRow][deathColumn] = enemyColor;
            self.goban[rowValue][columnValue] = @"+";
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
            //Set it back if no stones died
            //self.goban[deathRow][deathColumn] = enemyColor;
            self.goban[rowValue][columnValue] = @"+";
            [self setCapturedWhiteStones:tempWhiteCaptureCount];
            [self setCapturedBlackStones:tempBlackCaptureCount];
            NSLog(@"Set board back to its previous state");
            [self printBoardToConsole];
            NSLog(@"Illegal move: No liberties");
            return NO;
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
        NSLog(@"Checking stone with coordinates (%d,%d) against visited stone (%d,%d)", rowValueToCheck, columnValueToCheck, stoneInVisitedNodeList.rowValue, stoneInVisitedNodeList.columnValue);
        //Check if the coordinates match the coordinates of any nodes in the visited node queue
        if(stoneInVisitedNodeList.rowValue == rowValueToCheck && stoneInVisitedNodeList.columnValue == columnValueToCheck)
        {
            hasBeenVisited = YES;
        }
    }
    
    return hasBeenVisited;
}

-(void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
{
    //Verify row and coordinate values
    NSLog(@"Row coordingate: %d", rowValue);
    NSLog(@"Columns coordinate: %d", columnValue);
    
    //Get my color and my opponent's color
    NSString *myColor = self.goban[rowValue][columnValue];
    NSString *opponentColor = [[NSString alloc] init];
    if([myColor isEqualToString:@"B"])
    {
        opponentColor = @"W";
        NSLog(@"My opponent's color is %@", opponentColor);
    }
    else
    {
        opponentColor = @"B";
        NSLog(@"My opponent's color is %@", opponentColor);
    }
    
    //Check adjacent enemy stones
    //Check right
    NSLog(@"About to check right enemy stone where rowValue = %d and columnValue = %d", (rowValue+1), columnValue);
    if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:opponentColor])
    {
        NSLog(@"Checking right enemy stone");
        [self checkLifeOfStone:(rowValue+1) andForColumnValue:columnValue];
    }
    else if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:@"+"])
    {
        NSLog(@"Space to the right of stone was a free space");
    }
    else if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:myColor])
    {
        NSLog(@"Space to the right of stone was my color");
    }
    else
    {
        NSLog(@"Right enemy stone was out of bounds or was not an enemy");
    }
    //Check left
    NSLog(@"About to check left enemy stone");    
    if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:opponentColor])
    {
        NSLog(@"Checking left enemy stone");
        [self checkLifeOfStone:(rowValue-1) andForColumnValue:columnValue];
    }
    else if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:@"+"])
    {
        NSLog(@"Space to the left of stone was a free space");
    }
    else if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:myColor])
    {
        NSLog(@"Space to the left of stone was my color");
    }
    else
    {
        NSLog(@"Left enemy stone was out of bounds or was not an enemy");
    }
    //Check down
    NSLog(@"About to check down enemy stone");    
    if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:opponentColor])
    {
        NSLog(@"Checking down enemy stone");
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue+1)];
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:@"+"])
    {
        NSLog(@"Space to the down of stone was a free space");
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:myColor])
    {
        NSLog(@"Space to the down of stone was my color");
    }
    else
    {
        NSLog(@"Down enemy stone was out of bounds or was not an enemy");
    }
    //Check up
    NSLog(@"About to check up enemy stone");    
    if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:opponentColor])
    {
        NSLog(@"Checking up enemy stone");
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue-1)];
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:@"+"])
    {
        NSLog(@"Space to the up of stone was a free space");
    }
    else if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:myColor])
    {
        NSLog(@"Space to the up of stone was my color");
    }
    else
    {
        NSLog(@"Up enemy stone was out of bounds or was not an enemy");
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
    
    //You can easily check the life of a stone or cluster of stones by looking for any existing liberties.
    //Implement this using a breadth-first search.
    
    // BFS Algorithm:
    // 1. Mark the root as visited.
    // 2. Check for free spaces around the root, mark all nodes of the same color as visited. Add all adjacent nodes to the root as visited
    // 3. Add all adjacent nodes (stones of the same color) to the root to the end of the queue
        
    // When we've finished all the vertices adjacent to the root then
    // 1. Pick the vertex at the head of the queue
    // 2. Dequeue the vertex at the head of the queue
    // 3. Mark all unvisited vertices as visited and check for free spaces around the current node, ending if one is found.
    // 4. Add them to the end of the queue
       
    //WILL THERE EVER BE A POINT WEHERE THE QUEUE IS EMPTY BECAUSE THERE IS NO WHERE ELSE TO SEARCH AND THAT SCREWS THINGS UP?
    //CHECK THAT NO SPACES WILL EVER BE MARKED AS VISITED IF THEY AREN'T A WHITE STONE
    
    //Put the coordinates in a point and then add the point to the queue and visited nodes list
    Stone *vertex = [[Stone alloc] init];
    [vertex setColumnValue:columnValue];
    [vertex setRowValue:rowValue];
    NSLog(@"Set column value to: %d", vertex.columnValue);
    NSLog(@"Set row value to: %d", vertex.rowValue);
        
    //Push the root node into the queue (I don't actually think this is how you do it)
    // 1. Mark the root as visited.
    //NSMutableArray *queue = [NSMutableArray arrayWithObject:vertex];
    NSMutableArray *queue = [[NSMutableArray alloc] init];
    NSMutableArray *visitedNodes = [NSMutableArray arrayWithObject:vertex];
    
    NSString *goal = @"+";
    
    // 2. Check for free spaces around the root, mark all nodes of the same color as visited. Add all adjacent nodes to the root as visited
    //Check all spots around where the vertex is
    
    //Check spot to the right of vertex
    NSLog(@"Checking spot to the right of the vertex");
    if([self isInBounds:(vertex.rowValue+1) andForColumnValue:vertex.columnValue])
    {        
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue+1][vertex.columnValue] isEqualToString:allyColor])
        {
            NSLog(@"ALLY STONE TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue+1,vertex.columnValue);
            //Syntax from documentation: - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
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
            NSLog(@"Free space found to the right. Stone or stone cluster is alive (found at vertex)");
            NSLog(@"FREE SPACE TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue+1,vertex.columnValue);        
            NSLog(@"STONES ARE ALIVE (RIGHT)");
        }
        else
        {
            //If it is an ally piece, then what do we do?
            NSLog(@"PROBABLY AN ENEMY STONE RIGHT AT LOCATION (%d,%d)", vertex.rowValue+1,vertex.columnValue);            
            NSLog(@"Free space not found (right) and piece was most likely an enemy stone (found at vertex)");
        }
    }
    //Check spot to the left of the vertex
    NSLog(@"Checking spot to the left of the vertex");
    if([self isInBounds:(vertex.rowValue-1) andForColumnValue:vertex.columnValue] && stonesAreDead)
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue-1][vertex.columnValue] isEqualToString:allyColor])
        {
            NSLog(@"ALLY STONE TO THE LEFT AT LOCATION (%d,%d)", vertex.rowValue-1,vertex.columnValue);
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
            NSLog(@"Free space found to the left. Stone or stone cluster is alive (found at vertex)");
            NSLog(@"FREE SPACE TO THE LEFT AT LOCATION (%d,%d)", vertex.rowValue-1,vertex.columnValue);
            NSLog(@"STONES ARE ALIVE (LEFT)");
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            NSLog(@"PROBABLY AN ENEMY STONE LEFT AT LOCATION (%d,%d)", vertex.rowValue+1,vertex.columnValue);
            NSLog(@"Free space not found (left) and piece was most likely an enemy stone (found at vertex)");
        }
    }
    //Check spot below the vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue+1)] && stonesAreDead)
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue][vertex.columnValue+1] isEqualToString:allyColor])
        {
            NSLog(@"ALLY STONE TO THE DOWN AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue+1);
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
            NSLog(@"Free space found to the down. Stone or stone cluster is alive (found at vertex)");
            NSLog(@"FREE SPACE TO THE DOWN AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue+1);
            NSLog(@"STONES ARE ALIVE (DOWN)");
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            NSLog(@"Free space not found (down) and piece was most likely an enemy stone (found at vertex)");

        }
    }
    //Check the spot above the vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue-1)] && stonesAreDead)
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue][vertex.columnValue-1] isEqualToString:allyColor])
        {
            NSLog(@"ALLY STONE TO THE UP AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue-1);
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
            NSLog(@"Free space found to the down. Stone or stone cluster is alive (found at vertex)");
            NSLog(@"FREE SPACE TO THE UP AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue-1);
            NSLog(@"STONES ARE ALIVE (UP)");
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            NSLog(@"PROBABLY AN ENEMY STONE UP AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue-1);
            NSLog(@"Free space not found (up) and piece was not an ally stone (found at vertex)");
        }
    }
    
    NSLog(@"Checking nodes past the vertex, size of queue: %d", [queue count]);
    //Loop until the queue is empty
    while([queue count] > 0) 
    {
        NSLog(@"Checking nodes past the vertex (inside loop)");
        // 1. Pick the vertex at the head of the queue
        Stone *topOfQueue = queue[0];
        vertex.rowValue = topOfQueue.rowValue;
        vertex.columnValue = topOfQueue.columnValue;
        
        // 2. Dequeue the vertex at the head of the queue, syntax: - (void)removeObjectAtIndex:(NSUInteger)index
        [queue removeObjectAtIndex:0];
        
        // 3. Mark all unvisited vertices as visited (only if they aren't visited already!) and check for free spaces around the current node, ending if one is found.
        //Check spot to the right of vertex
        if([self isInBounds:(vertex.rowValue+1) andForColumnValue:vertex.columnValue] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(vertex.rowValue+1) andForColumnValue:columnValue])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[vertex.rowValue+1][vertex.columnValue] isEqualToString:allyColor])
            {
                NSLog(@"ALLY STONE TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue+1,vertex.columnValue);
                //Syntax from documentation: - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
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
                NSLog(@"FREE SPACE TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue+1,vertex.columnValue);
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
                NSLog(@"Stone or stone cluster is alive");                
            }
            else
            {
                NSLog(@"MOST LIKELY AN ENEMY TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue+1,vertex.columnValue);
            }
        }
        //Check spot to the left of the vertex
        if([self isInBounds:(vertex.rowValue-1) andForColumnValue:vertex.columnValue] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(vertex.rowValue-1) andForColumnValue:vertex.columnValue])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[vertex.rowValue-1][vertex.columnValue] isEqualToString:allyColor])
            {
                NSLog(@"ALLY STONE TO THE LEFT AT LOCATION (%d,%d)", vertex.rowValue-1,vertex.columnValue);
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
                NSLog(@"FREE SPACE TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue-1,vertex.columnValue);
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
                NSLog(@"Stone or stone cluster is alive");                
            }
            else
            {
                NSLog(@"MOST LIKELY AN ENEMY TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue-1,vertex.columnValue);
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
        //Check spot below the vertex
        if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue+1)] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:rowValue andForColumnValue:(columnValue+1)])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[vertex.rowValue][vertex.columnValue+1] isEqualToString:allyColor])
            {
                NSLog(@"ALLY STONE TO THE DOWN AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue+1);
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
                NSLog(@"FREE SPACE TO THE DOWN AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue+1);
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
                NSLog(@"Stone or stone cluster is alive");
            }
            else
            {
                NSLog(@"MOST LIKELY AN ENEMY TO THE RIGHT AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue+1);
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
        //Check the spot above the vertex
        if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue-1)] && stonesAreDead && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:rowValue andForColumnValue:(vertex.columnValue-1)])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[vertex.rowValue][vertex.columnValue-1] isEqualToString:allyColor])
            {
                NSLog(@"ALLY STONE TO THE UP AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue-1);
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
                NSLog(@"FREE SPACE TO THE UP AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue-1);
                //We have found a free space, so remove all objects from the queue
                [queue removeAllObjects];
                stonesAreDead = NO;
                NSLog(@"Stone or stone cluster is alive");
            }
            else
            {
                NSLog(@"MOST LIKELY AN ENEMY TO THE UP AT LOCATION (%d,%d)", vertex.rowValue,vertex.columnValue-1);
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
    }
    
    //If stones are dead, set them back to unplayed spots
    if(stonesAreDead)
    {
        NSLog(@"Killing stones (should not be called after stones are determined to be alive)");
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
        NSLog(@"Old number of captured black stones: %d", self.capturedBlackStones);
        //Add the number of dead stones to black's captured stone count
        [self setCapturedBlackStones:(self.capturedBlackStones + [stonesToKill count])];
        NSLog(@"New number of captured black stones: %d", self.capturedBlackStones);
    }
    else
    {
        //Add the number of dead stones to white's dead stone count
        NSLog(@"Old number of captured white stones: %d", self.capturedWhiteStones);
        //Add the number of dead stones to white's captured stone count
        [self setCapturedWhiteStones:(self.capturedWhiteStones + [stonesToKill count])];
        NSLog(@"New number of captured white stones: %d", self.capturedWhiteStones);
    }
        
    //This takes the nodes from the visited Nodes array and sets them back to "+"
    for(int i=0;i<[stonesToKill count]; i++)
    {
        stone = stonesToKill[i];
        self.goban[stone.rowValue][stone.columnValue] = @"+";
        NSLog(@"KILLING STONE at row %d and column %d", stone.rowValue, stone.columnValue);
    }
    NSLog(@"Killed stones");
    [self printBoardToConsole];
}

@end