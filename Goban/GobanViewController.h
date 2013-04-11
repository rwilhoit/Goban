//
//  GobanViewController.h
//  Goban
//
//  Created by Raj Wilhoit on 3/17/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Goban.h"

@interface GobanViewController : UIViewController {
    BOOL isBlacksTurn;
}
- (IBAction)pressedBack:(id)sender;

-(void)drawBoard; 
-(void)score;

@end
