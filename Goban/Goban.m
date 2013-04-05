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
        }
        [printRow appendString:@"\n"];
    }
    
    NSLog(@"%@", printRow);

    
}

@end