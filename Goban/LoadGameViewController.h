//
//  LoadGameViewController.h
//  Goban
//
//  Created by Raj Wilhoit on 7/29/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData+MagicalRecord.h"
#import "GameRecord.h"
#import "GobanViewController.h"

@interface LoadGameViewController : UITableViewController {
    NSString *hashValue;
}

- (IBAction)deleteButtonSelected:(id)sender;

@property (nonatomic) NSString *hashValue;

@end
