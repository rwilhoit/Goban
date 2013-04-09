//
//  Goban.h
//  Goban
//
//  Created by Raj Wilhoit on 3/18/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stone.h"
#define BOARD_SIZE 361
#define ROW_LENGTH 18
#define COLUMN_LENGTH 18

@interface Goban : NSObject {
    NSMutableArray *goban;  //Go board object
    NSString *lastMove;     //Specifies the coordinates of the last move
    NSString *turn;         //Specifies who's turn it is
    int whiteStones;
    int blackStones;
    int capturedBlackStones;
    int capturedWhiteStones;
}

@property (nonatomic, retain) NSMutableArray *goban;
@property (nonatomic, retain) NSString *lastMove;
@property (nonatomic, retain) NSString *turn;

@property (nonatomic) int whiteStones;

-(id)init:(NSMutableArray *) goban;
-(void)printBoardToConsole;
-(BOOL)isLegalMove:(NSString *)newMove;
-(BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue;
-(BOOL)checkIfNodeHasBeenVisited:(NSMutableArray *)visitedNodeList forRowValue:(int)rowValueToCheck andForColumnValue:(int)columnValueToCheck;
-(void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
-(void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue;
-(void)killStones:(NSMutableArray *)stonesToKill;



@end
