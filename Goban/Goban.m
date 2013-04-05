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
    for(int i=0;i<COLUMN_LENGTH-1; i++)
    {
        for(int j=0; j<ROW_LENGTH-1; j++)
        {
            [printRow appendString:self.goban[j][i]];
            [printRow appendString:@" "];
        }
        [printRow appendString:@"\n"];
    }
    
    NSLog(@"%@", printRow);
}

-(BOOL)isLegalMove:(NSString*)newMove
{
    //Check if the move is in bounds
    //[returnedString isEqualToString: @"thisString"]
    //Get specific coordinates from title
    NSArray *coordinateArray = [newMove componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    int rowValue = [coordinateArray[0] integerValue];
    int columnValue = [coordinateArray[1] integerValue];
    NSLog(@"Row coordingate: %d", rowValue);
    NSLog(@"Columns coordinate: %d", columnValue);

    if(rowValue < 0 || rowValue > 18 || columnValue < 0 || columnValue > 18)
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

@end