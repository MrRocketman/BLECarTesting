//
//  MNBLEControlsTableViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/16/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNBLEControlsTableViewController.h"
#import "MNBLEControlsSegmentsTableViewCell.h"
#import "MNBluetoothManager.h"

@interface MNBLEControlsTableViewController()

@end


@implementation MNBLEControlsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
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
    return [[MNBluetoothManager sharedBluetoothManager] commandCategoriesCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *category = [[[MNBluetoothManager sharedBluetoothManager] commandCategories] objectAtIndex:section];
    return [[MNBluetoothManager sharedBluetoothManager] commandsCountForCategory:category];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *category = [[[MNBluetoothManager sharedBluetoothManager] commandCategories] objectAtIndex:section];
    return category;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *category = [[[MNBluetoothManager sharedBluetoothManager] commandCategories] objectAtIndex:indexPath.section];
    NSMutableDictionary *commandDictionaryForCell = [[MNBluetoothManager sharedBluetoothManager] commandForCategory:category atIndex:(int)indexPath.row];
    
    MNBLEControlsSegmentsTableViewCell *cell;
    if([commandDictionaryForCell objectForKey:@"factoryCharacter"] != nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"twoSegmentsCell" forIndexPath:indexPath];
    }
    else if([[commandDictionaryForCell objectForKey:@"numberOfStates"] integerValue] > 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"segmentBelowLabelCell" forIndexPath:indexPath];
    }
    else if([[commandDictionaryForCell objectForKey:@"numberOfStates"] integerValue] >= 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"segmentByLabelCell" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }
    
    // Give the cell its data
    [cell setCommandDictionary:commandDictionaryForCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *category = [[[MNBluetoothManager sharedBluetoothManager] commandCategories] objectAtIndex:indexPath.section];
    NSDictionary *commandDictionaryForCell = [[MNBluetoothManager sharedBluetoothManager] commandForCategory:category atIndex:(int)indexPath.row];
    
    if([commandDictionaryForCell objectForKey:@"factoryCharacter"] != nil)
    {
        return 82;
    }
    else if([[commandDictionaryForCell objectForKey:@"numberOfStates"] integerValue] > 3)
    {
        return 82;
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *category = [[[MNBluetoothManager sharedBluetoothManager] commandCategories] objectAtIndex:indexPath.section];
    NSDictionary *commandDictionaryForCell = [[MNBluetoothManager sharedBluetoothManager] commandForCategory:category atIndex:(int)indexPath.row];
    
    if([commandDictionaryForCell objectForKey:@"factoryCharacter"] != nil)
    {
        return 82;
    }
    else if([[commandDictionaryForCell objectForKey:@"numberOfStates"] integerValue] > 3)
    {
        return 82;
    }
    else
    {
        return 44;
    }
}

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
