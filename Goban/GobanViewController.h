//
//  GobanViewController.h
//  Goban
//
//  Created by Raj Wilhoit on 3/17/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface GobanViewController : UIViewController

-(void)playStone;
-(void)score;
-(BOOL *)checkKo;

- (IBAction)genericButton:(id)sender;

@end
