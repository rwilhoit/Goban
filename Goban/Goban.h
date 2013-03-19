//
//  Goban.h
//  Goban
//
//  Created by Raj Wilhoit on 3/18/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goban : NSObject {
    NSMutableArray *goban;
}

@property (nonatomic, retain) NSMutableArray *goban;

-(id)init:(NSMutableArray *) goban;

@end
