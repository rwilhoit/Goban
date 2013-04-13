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
    NSMutableArray *goban;               //Go board object
    NSMutableArray *previousStateOfBoard; //Previous state of the Go board object, used for backs and ko checks
    NSString *turn;                      //Whose turn it is
    int moveNumber;                      //The move number
    int whiteStones;                     //Total number of white stones
    int blackStones;                     //Total number of black stones
    int capturedBlackStones;             //Number of captured black stones
    int capturedWhiteStones;             //Number of captured white stones
    double komi;                         //Komi, specified as a double because komi is oftem 6.5
    BOOL redrawBoardNeeded;              //A flag on when to redraw the board and when to just add a stone to it
}

@property (nonatomic, retain) NSMutableArray *goban;
@property (nonatomic, retain) NSMutableArray *previousStateOfBoard;
@property (nonatomic, retain) NSString *turn;
@property (nonatomic) int moveNumber;
@property (nonatomic) int whiteStones;
@property (nonatomic) int blackStones;
@property (nonatomic) int capturedBlackStones;
@property (nonatomic) int capturedWhiteStones;
@property (nonatomic) double komi;
@property (nonatomic) BOOL redrawBoardNeeded;

-(id)init:(NSMutableArray *) goban;
-(void)printBoardToConsole;
-(BOOL)isLegalMove:(int)rowValue andForColumnValue:(int)columnValue;
-(BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue;
-(BOOL)checkIfNodeHasBeenVisited:(NSMutableArray *)visitedNodeList forRowValue:(int)rowValueToCheck andForColumnValue:(int)columnValueToCheck;
-(void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
-(void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue;
-(void)killStones:(NSMutableArray *)stonesToKill;
-(void)back;

@end
