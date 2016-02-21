//
//  Stone.m
//  Goban
//
//  Created by Raj Wilhoit on 3/19/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "Stone.h"

@implementation Stone

-(id)init:(NSNumber *)goStone {
    if (self = [super init]) {
        _stone = goStone;
    }
    return self;
}

@end