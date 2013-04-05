//
//  Goban.h
//  Goban
//
//  Created by Raj Wilhoit on 3/18/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GobanViewController.h"

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
- (void)printBoardToConsole;
- (BOOL)isLegalMove:(NSString*)newMove;

@end
