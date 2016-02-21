//
//  BoardSerializationUtility.m
//  Goban
//
//  Created by Wilhoit, Raj on 2/21/16.
//  Copyright © 2016 UF.rajwilhoit. All rights reserved.
//

#import "BoardSerializationUtility.h"
#import "GobanConstants.h"

@implementation BoardSerializationUtility

+ (void)printBoardToConsole:(NSArray *)goban {
    NSMutableString *printRow = [[NSMutableString alloc] init];
    [printRow appendString:@"\n"];
    for(int i = 0 ; i < GobanColumnLength; i++) {
        for(int j=0; j < GobanRowLength; j++) {
            [printRow appendString:goban[j][i]];
            [printRow appendString:@" "];
        }
        [printRow appendString:@"\n"];
    }
    
    NSLog(@"%@", printRow);
}

+ (NSString *)serializedBoard:(NSArray *)goban {
    NSMutableString *board_string = [[NSMutableString alloc] init];
    for(int i = 0; i < GobanColumnLength; i++) {
        for(int j = 0; j < GobanRowLength; j++) {
            [board_string appendString:goban[j][i]];
        }
    }
    return board_string;
}

+ (NSMutableArray *)boardRow {
    return [NSMutableArray arrayWithObjects:GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
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
            if(![[NSString stringWithFormat:@"%C", [boardString characterAtIndex:boardPosition]] isEqualToString:GobanEmptySpotString]) {
                if([[NSString stringWithFormat:@"%C", [boardString characterAtIndex:boardPosition]] isEqualToString:GobanBlackSpotString]) {
                    deserializedBoard[j][i] = GobanBlackSpotString;
                }
                else if([[NSString stringWithFormat:@"%C", [boardString characterAtIndex:boardPosition]] isEqualToString:GobanWhiteSpotString]) {
                    deserializedBoard[j][i] = GobanWhiteSpotString;
                }
            }
            boardPosition++;
        }
    }
    
    return deserializedBoard;
}

@end
