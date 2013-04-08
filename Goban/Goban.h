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
    NSMutableArray *goban;
    NSString *lastMove;
    int whiteStones;
    int blackStones;
    int capturedBlackStones;
    int capturedWhiteStones;
}

@property (nonatomic, retain) NSMutableArray *goban;
@property (nonatomic, retain) NSString *lastMove;
@property (nonatomic) int whiteStones;

-(id)init:(NSMutableArray *) goban;
-(void)printBoardToConsole;
-(BOOL)isLegalMove:(NSString *)newMove;
-(BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue;
-(void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
-(void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue;
-(void)killStones:(NSMutableArray *)stonesToKill;



@end
