//
//  BoardSerializationUtility.h
//  Goban
//
//  Created by Wilhoit, Raj on 2/21/16.
//  Copyright © 2016 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardSerializationUtility : NSObject

+ (void)printBoardToConsole:(NSArray *)goban;
+ (NSMutableArray *)emptyMutableBoardArray;
+ (NSString *)serializedBoard:(NSArray *)goban;
+ (NSMutableArray *)deserializedBoard:(NSString *)boardString;

@end
