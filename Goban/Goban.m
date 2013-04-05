//
//  Goban.m
//  Goban
//
//  Created by Raj Wilhoit on 3/18/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "Goban.h"

@implementation Goban

//Synthesized values
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
        return NO;
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
        [self checkLifeOfStone:(rowValue+1) andForColumnValue:columnValue];
    }
    //Check left
    if([self isInBounds:(rowValue-1) andForColumnValue:columnValue] && [self.goban[rowValue-1][columnValue] isEqualToString:opponentColor])
    {
        [self checkLifeOfStone:(rowValue-1) andForColumnValue:columnValue];
    }
    //Check up
    if([self isInBounds:rowValue andForColumnValue:(columnValue+1)] && [self.goban[rowValue][columnValue+1] isEqualToString:opponentColor])
    {
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue+1)];
    }
    //Check down
    if([self isInBounds:rowValue andForColumnValue:(columnValue-1)] && [self.goban[rowValue][columnValue-1] isEqualToString:opponentColor])
    {
        [self checkLifeOfStone:rowValue andForColumnValue:(columnValue-1)];
    }

}

@end