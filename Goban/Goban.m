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
@synthesize lastMove;
@synthesize whiteStones;

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
    for(int i=0;i<COLUMN_LENGTH; i++)
    {
        for(int j=0; j<ROW_LENGTH; j++)
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
    if(rowValue < 0 || rowValue > ROW_LENGTH || columnValue < 0 || columnValue > COLUMN_LENGTH)
    {
        return NO;
    }
    return YES;
}

-(BOOL)isLegalMove:(NSString*)newMove
{
    //Get specific coordinates from title
    NSArray *coordinateArray = [newMove componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    int rowValue = [coordinateArray[0] integerValue];
    int columnValue = [coordinateArray[1] integerValue];
    NSLog(@"Row coordingate: %d", rowValue);
    NSLog(@"Columns coordinate: %d", columnValue);

    if(![self isInBounds:rowValue andForColumnValue:columnValue])
    {
        NSLog(@"Illegal move: move was out of bounds");
        return NO;
    }
    //Check if the move is a ko
    if([newMove isEqualToString:self.lastMove])
    {
        NSLog(@"Illegal move: Ko");
        return NO;
    }
    
    //Check if the move has already been played
    if(![self.goban[rowValue][columnValue] isEqualToString:@"+"])
    {
        NSLog(@"Illegal move: move has already been played");
        return NO;
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
    if([self isInBounds:(rowValue+1) andForColumnValue:columnValue] && [self.goban[rowValue+1][columnValue] isEqualToString:opponentColor])
    {
        NSLog(@"Checking right enemy stone");
        [self checkLifeOfStone:(rowValue+1) andForColumnValue:columnValue];
    }
    //Check left
    if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:opponentColor])
    {
        NSLog(@"Checking left enemy stone");
        [self checkLifeOfStone:(rowValue-1) andForColumnValue:columnValue];
    }
    //Check up
    if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:opponentColor])
    {
        NSLog(@"Checking up enemy stone");
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue+1)];
    }
    //Check down
    if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:opponentColor])
    {
        NSLog(@"Checking down enemy stone");
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue-1)];
    }
}

-(void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue
{
    //It is already implied that if we are at this point in the code, then the piece at the given location is a valid piece
    
    //Figure out what is an enemy color and what is an ally piece
    NSString *allyColor = [[NSString alloc] init];  //Color of ally stones
    NSString *enemyColor = [[NSString alloc] init]; //Color of enemy stones
    BOOL stonesAreDead = YES;                        //Flag for if the stones are dead or not
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
    if([self isInBounds:(vertex.rowValue+1) andForColumnValue:vertex.columnValue])
    {        
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue+1][vertex.columnValue] isEqualToString:allyColor])
        {
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
            NSLog(@"Stone or stone cluster is alive");            
        }
        else
        {
            //If it is an ally piece, then what do we do?
        }
    }
    //Check spot to the left of the vertex
    if([self isInBounds:(vertex.rowValue-1) andForColumnValue:vertex.columnValue] && [queue count] > 0)
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
            NSLog(@"Stone or stone cluster is alive");            
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
        }
    }
    //Check spot above the vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue+1)] && [queue count] > 0)
    {
        //If it is an ally color, add it to the visited queue and the actual queue
        if([self.goban[vertex.rowValue][vertex.columnValue+1] isEqualToString:allyColor])
        {
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
            NSLog(@"Stone or stone cluster is alive");            
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
        }
    }
    //Check the spot below the vertex
    if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue-1)] && [queue count] > 0)
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
            NSLog(@"Stone or stone cluster is alive");            
        }
        else
        {
            //If this piece is a random piece, a wall piece, or something else, then just do nothing.
        }
    }
        
    //Loop until the queue is empty
    while([queue count] > 0) 
    {
        // 1. Pick the vertex at the head of the queue
        Stone *topOfQueue = queue[0];
        vertex.rowValue = topOfQueue.rowValue;
        vertex.columnValue = topOfQueue.columnValue;
        
        // 2. Dequeue the vertex at the head of the queue, syntax: - (void)removeObjectAtIndex:(NSUInteger)index
        [queue removeObjectAtIndex:0];
        
        // 3. Mark all unvisited vertices as visited (only if they aren't visited already!) and check for free spaces around the current node, ending if one is found.
        //Check spot to the right of vertex
        if([self isInBounds:(vertex.rowValue+1) andForColumnValue:vertex.columnValue] && [queue count] > 0 && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(vertex.rowValue+1) andForColumnValue:columnValue])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[vertex.rowValue+1][vertex.columnValue] isEqualToString:allyColor])
            {
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
                NSLog(@"Stone or stone cluster is alive");                
            }
            else
            {
                //If it is an ally piece, then what do we do?
            }
        }
        //Check spot to the left of the vertex
        if([self isInBounds:(vertex.rowValue-1) andForColumnValue:vertex.columnValue] && [queue count] > 0 && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:(vertex.rowValue-1) andForColumnValue:vertex.columnValue])
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
                NSLog(@"Stone or stone cluster is alive");                
            }
            else
            {
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
        //Check spot above the vertex
        if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue+1)] && [queue count] > 0 && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:rowValue andForColumnValue:(columnValue+1)])
        {
            //If it is an ally color, add it to the visited queue and the actual queue
            if([self.goban[vertex.rowValue][vertex.columnValue+1] isEqualToString:allyColor])
            {
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
                NSLog(@"Stone or stone cluster is alive");
            }
            else
            {
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
        //Check the spot below the vertex
        if([self isInBounds:vertex.rowValue andForColumnValue:(vertex.columnValue-1)] && [queue count] > 0 && ![self checkIfNodeHasBeenVisited:visitedNodes forRowValue:rowValue andForColumnValue:(vertex.columnValue-1)])
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
                NSLog(@"Stone or stone cluster is alive");
            }
            else
            {
                //If this piece is a random piece, a wall piece, or something else, then just do nothing.
            }
        }
    }
    
    //If stones are dead, set them back to unplayed spots
    if(stonesAreDead)
    {
        NSLog(@"Killing stones");
        [self printBoardToConsole];
        [self killStones:visitedNodes];
    }
}

-(void)killStones:(NSMutableArray *)stonesToKill
{
    Stone *stone = [[Stone alloc] init];
    //This takes the nodes from the visited Nodes array and sets them back to "+"
    for(int i=0;i<[stonesToKill count]; i++)
    {
        stone = stonesToKill[i];
        self.goban[stone.rowValue][stone.columnValue] = @"+";
    }
    NSLog(@"Killed stones");
    [self printBoardToConsole];
}


@end