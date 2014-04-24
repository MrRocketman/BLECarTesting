//
//  MNCarLightsTableViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarLightsTableViewController.h"
#import "MNBluetoothManager.h"
#import "MNCarToggleTableViewCell.h"
#import "MNCarSegmentsTableViewCell.h"

@interface MNCarLightsTableViewController ()

@property(strong, nonatomic) NSArray *lightCategories;

@end

@implementation MNCarLightsTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.lightCategories = [[MNBluetoothManager sharedBluetoothManager] commandCategoriesMatchingSearchString:@"Light"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.lightCategories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[MNBluetoothManager sharedBluetoothManager] commandsCountForCategory:self.lightCategories[section]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.lightCategories[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *category = [self.lightCategories objectAtIndex:indexPath.section];
    NSMutableDictionary *commandForCell = [[MNBluetoothManager sharedBluetoothManager] commandForCategory:category atIndex:(int)indexPath.row];
    
    // Headlights needs a special cell
    if([[commandForCell objectForKey:@"title"] isEqualToString:@"Headlights"])
    {
        MNCarSegmentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"segmentsCell" forIndexPath:indexPath];
        
        // Set the command so it can send BLE data when pushed
        cell.command = commandForCell;
        
        return cell;
    }
    // All other cells are ToggleCells
    else
    {
        MNCarToggleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToggleCell" forIndexPath:indexPath];
        
        // Set the command so it can send BLE data when pushed
        cell.command = commandForCell;
        cell.shouldSendFactoryCommand = NO;
        
        return cell;
    }
    
    return nil;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
