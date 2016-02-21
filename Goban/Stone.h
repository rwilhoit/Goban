//
//  Stone.h
//  Goban
//
//  Created by Raj Wilhoit on 3/19/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//  (Essentially this is just a point class)

#import <Foundation/Foundation.h>

@interface Stone : NSObject

@property (weak, nonatomic) NSNumber *stone;
@property (nonatomic) int rowValue;
@property (nonatomic) int columnValue;

@end
