//
//  LoadGameViewController.m
//  Goban
//
//  Created by Raj Wilhoit on 7/29/13.
//  Copyright (c) 2013 UF.rajwilhoit. All rights reserved.
//

#import "LoadGameViewController.h"

@interface LoadGameViewController ()
{
    NSMutableArray *dataArray;
}

@end

@implementation LoadGameViewController

@synthesize hashValue;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArray = [NSMutableArray new];
    
    //Refresh data
    [self refreshData];
}

-(void) refreshData
{
    [dataArray removeAllObjects];
    NSArray *allRecords = [GameRecord findAllSortedBy:@"date" ascending:YES];
    [dataArray addObjectsFromArray:allRecords];
    [self.tableView reloadData];
}

- (IBAction)deleteButtonSelected:(id)sender {
    [GameRecord MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] saveToPersistentStoreAndWait];
    [self refreshData];
}

-(void) notificationNewGameRecordAdded:(NSNotification*)notification
{
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // Configure the cell...
    GameRecord *gameRecord = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = gameRecord.date;
    cell.detailTextLabel.text = gameRecord.hashValue;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GobanViewSegue"])
    {
        GobanViewController *gobanViewController = (GobanViewController *)[[segue destinationViewController] topViewController];
        NSLog(@"self.hashValue = %@", self.hashValue);
        [gobanViewController setBoardLoadRequest:YES];
        [gobanViewController setGameRecordHash:self.hashValue];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Selected row %ld", (long)indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self setHashValue:cell.detailTextLabel.text];
    
    [self performSegueWithIdentifier:@"GobanViewSegue" sender:self];
}

@end
