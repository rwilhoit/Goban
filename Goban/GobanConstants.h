//
//  GobanConstants.h
//  Goban
//
//  Created by Wilhoit, Raj on 2/21/16.
//  Copyright © 2016 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const GobanWhiteSpotString = @"W";
static NSString * const GobanBlackSpotString = @"B";
static NSString * const GobanEmptySpotString = @"+";

static NSString * const GobanVisitedWhiteSpotString = @"w";
static NSString * const GobanVisitedBlackSpotString = @"b";

static NSString * const GobanBoardImageFileName = @"Goban.png";
static NSString * const GobanBlackStoneFileName = @"blackStone.png";
static NSString * const GobanWhiteStoneFileName = @"whiteStone.png";

static NSUInteger const GobanBoardSize = 361;
static NSUInteger const GobanRowLength = 19;
static NSUInteger const GobanColumnLength = 19;
static NSUInteger const GobanMiddleOffsetSize = 96;

static CGFloat const GobanKomiAmount = 6.5;
static CGFloat const GobanSpaceSize = 40.4210526316;
