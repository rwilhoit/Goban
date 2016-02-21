//
//  BoardSerializationUtility.m
//  Goban
//
//  Created by Wilhoit, Raj on 2/21/16.
//  Copyright © 2016 UF.rajwilhoit. All rights reserved.
//

#import "BoardSerializationUtility.h"

#define BOARD_SIZE 361
#define ROW_LENGTH 18
#define COLUMN_LENGTH 18

@implementation BoardSerializationUtility

static NSString * const kEmptySpot = @"+";

+ (void)printBoardToConsole:(NSArray *)goban {
    NSMutableString *printRow = [[NSMutableString alloc] init];
    [printRow appendString:@"\n"];
    for(int i = 0 ; i < COLUMN_LENGTH + 1; i++) {
        for(int j=0; j < ROW_LENGTH+1; j++) {
            [printRow appendString:goban[j][i]];
            [printRow appendString:@" "];
        }
        [printRow appendString:@"\n"];
    }
    
    NSLog(@"%@", printRow);
}

+ (NSString *)serializedBoard:(NSArray *)goban {
    NSMutableString *board_string = [[NSMutableString alloc] init];
    for(int i = 0; i < COLUMN_LENGTH + 1; i++) {
        for(int j = 0; j < ROW_LENGTH + 1; j++) {
            [board_string appendString:goban[j][i]];
        }
    }
    return board_string;
}

+ (NSMutableArray *)boardRow {
    return [NSMutableArray arrayWithObjects:kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            kEmptySpot,
            nil];
}

+ (NSMutableArray *)emptyMutableBoardArray {
    return [NSMutableArray arrayWithObjects:
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow],
            [BoardSerializationUtility boardRow], nil];
}

+ (NSMutableArray *)deserializedBoard:(NSString *)boardString {
    NSMutableArray *deserializedBoard = [BoardSerializationUtility emptyMutableBoardArray];
    int boardPosition = 0;
    for(int i = 0; i < deserializedBoard.count; i++) {
        for(int j = 0;j < [deserializedBoard[i] count]; j++) {
            if(![[NSString stringWithFormat:@"%C", [boardString characterAtIndex:boardPosition]] isEqualToString:kEmptySpot]) {
                if([[NSString stringWithFormat:@"%C", [boardString characterAtIndex:boardPosition]] isEqualToString:@"B"]) {
                    deserializedBoard[j][i] = @"B";
                }
                else if([[NSString stringWithFormat:@"%C", [boardString characterAtIndex:boardPosition]] isEqualToString:@"W"]) {
                    deserializedBoard[j][i] = @"W";
                }
            }
            boardPosition++;
        }
    }
    
    return deserializedBoard;
}

@end
