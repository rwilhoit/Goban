//
//  GameRecord.h
//  Goban
//
//  Created by Raj Wilhoit on 7/29/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GameRecord : NSManagedObject

@property (nonatomic, retain) NSString * board;
@property (nonatomic, retain) NSNumber * capturedWhiteStones;
@property (nonatomic, retain) NSNumber * capturedBlackStones;
@property (nonatomic, retain) NSString * blackTime;
@property (nonatomic, retain) NSString * whiteTime;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * turn;
@property (nonatomic, retain) NSNumber * moveNumber;
@property (nonatomic, retain) NSString * hashValue;

@end
