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
#define BOARD_SIZE 361
#define ROW_LENGTH 19
#define COLUMN_LENGTH 19

@interface GobanViewController : UIViewController {
    BOOL isBlacksTurn;
}

-(void)playStone;
-(void)score;

- (IBAction)hideButton:(id)sender;
- (IBAction)playStone:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *goStone;


@end
