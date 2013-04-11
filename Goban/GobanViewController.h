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

-(void)drawBoard; //Called in the event that someone plays a stone
-(void)playStone;
-(void)score;

- (IBAction)hideButton:(id)sender;
- (IBAction)playStone:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *goStone;


@end
