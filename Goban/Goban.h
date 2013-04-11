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
    NSMutableArray *potentialStateOfBoard; //Potential previous state of the Go board object, used for checking kos
    Stone *currentMove;                  //The location of the new move you are about to attempt
    Stone *lastMove;                     //The location of the last move
    NSString *turn;                      //Whose turn it is
    int moveNumber;                      //The move number
    int whiteStones;                     //Total number of white stones
    int blackStones;                     //Total number of black stones
    int capturedBlackStones;             //Number of captured black stones
    int capturedWhiteStones;             //Number of captured white stones
    double komi;                         //Komi, specified as a double because komi is oftem 6.5
}

@property (nonatomic, retain) NSMutableArray *goban;
@property (nonatomic, retain) NSMutableArray *previousStateOfBoard;
@property (nonatomic, retain) NSMutableArray *potentialStateOfBoard;
@property (nonatomic, retain) Stone *currentMove;
@property (nonatomic, retain) Stone *lastMove;
@property (nonatomic, retain) NSString *turn;
@property (nonatomic) int moveNumber;
@property (nonatomic) int whiteStones;
@property (nonatomic) int blackStones;
@property (nonatomic) int capturedBlackStones;
@property (nonatomic) int capturedWhiteStones;
@property (nonatomic) double komi;

-(id)init:(NSMutableArray *) goban;
-(void)printBoardToConsole;
-(BOOL)isLegalMove:(int)rowValue andForColumnValue:(int)columnValue;
-(BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue;
-(BOOL)checkIfNodeHasBeenVisited:(NSMutableArray *)visitedNodeList forRowValue:(int)rowValueToCheck andForColumnValue:(int)columnValueToCheck;
-(BOOL)checkKo:(int)rowValueToCheck andForColumnValue:(int)columnValueToCheck;
-(void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
-(void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue;
-(void)killStones:(NSMutableArray *)stonesToKill;
-(id) copyWithZone: (NSZone *) zone;




@end
