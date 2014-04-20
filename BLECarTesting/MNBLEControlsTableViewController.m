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
    return [[MNBluetoothManager commandSectionDictionaryArrays] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[MNBluetoothManager commandSectionDictionaryArrays] objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[MNBluetoothManager commandSectionNames] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commandDictionaryForCell = [[[MNBluetoothManager commandSectionDictionaryArrays] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    MNBLEControlsSegmentsTableViewCell *cell;
    if([commandDictionaryForCell objectForKey:@"factoryCommand"] != nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"twoSegmentsCell" forIndexPath:indexPath];
    }
    else if([[commandDictionaryForCell objectForKey:@"numberOfStates"] integerValue] > 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"segmentBelowLabelCell" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"segmentByLabelCell" forIndexPath:indexPath];
    }
    
    // Give the cell its data
    [cell setCommandDictionary:commandDictionaryForCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commandDictionaryForCell = [[[MNBluetoothManager commandSectionDictionaryArrays] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if([commandDictionaryForCell objectForKey:@"factoryCommand"] != nil)
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
    NSDictionary *commandDictionaryForCell = [[[MNBluetoothManager commandSectionDictionaryArrays] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if([commandDictionaryForCell objectForKey:@"factoryCommand"] != nil)
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
