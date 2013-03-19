//
//  Stone.m
//  Goban
//
//  Created by Raj Wilhoit on 3/19/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "Stone.h"

@implementation Stone
@synthesize stone;

-(id)init:(NSNumber *) goStone
{
    if (self = [super init])
    {
        self.stone = goStone;
    }
    return self;
}

-(id)init
{
    return [super init];
}

-(CALayer *)drawStone{
    return nil;
}

@end