//
//  Goban.h
//  Goban
//
//  Created by Raj Wilhoit on 3/18/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GobanViewController.h"
#import "Stone.h"
#define BOARD_SIZE 361
#define ROW_LENGTH 18
#define COLUMN_LENGTH 18

@class Stone;

@interface Goban : NSObject

@property (nonatomic, strong) NSMutableArray *goban;
@property (nonatomic, strong) NSMutableArray *previousStateOfBoard;
@property (nonatomic, strong) NSString *turn;
@property (nonatomic, strong) NSString *boardCreationDate;
@property (nonatomic, strong) NSString *hashValue;
@property (nonatomic) int moveNumber;
@property (nonatomic) int whiteStones;
@property (nonatomic) int blackStones;
@property (nonatomic) int capturedBlackStones;
@property (nonatomic) int capturedWhiteStones;
@property (nonatomic) int previousCapturedBlackStones;
@property (nonatomic) int previousCapturedWhiteStones;
@property (nonatomic) double komi;
@property (nonatomic) BOOL redrawBoardNeeded;
@property (nonatomic) BOOL whitePassed;
@property (nonatomic) BOOL blackPassed;

- (id)init:(NSMutableArray *) goban;
- (void)printBoardToConsole;
- (BOOL)isLegalMove:(int)rowValue andForColumnValue:(int)columnValue;
- (BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue;
- (BOOL)checkIfNodeHasBeenVisited:(NSMutableArray *)visitedNodeList
                      forRowValue:(int)rowValueToCheck
                andForColumnValue:(int)columnValueToCheck;
- (void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
- (void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue;
- (void)killStones:(NSMutableArray *)stonesToKill;
- (void)back;
- (void)markStoneClusterAsDeadFor:(int)rowValue andForColumnValue:(int)columnValue andForColor:(NSString*)color;
- (NSString *)serializeBoard;
- (NSMutableArray *)deserializeBoard:(NSString *)boardString;


@end
