//
//  Stone.m
//  Goban
//
//  Created by Raj Wilhoit on 3/19/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "Stone.h"

@implementation Stone

- (instancetype)initWithWithRow:(int)row column:(int)column {
    if (self = [super init]) {
        _row = row;
        _column = column;
    }
    
    return self;
}

@end