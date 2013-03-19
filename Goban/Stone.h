//
//  Stone.h
//  Goban
//
//  Created by Raj Wilhoit on 3/19/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stone : NSObject {
    NSNumber *color;
}

@property (weak, nonatomic) NSNumber *stone;

-(CALayer *)drawStone;

@end
