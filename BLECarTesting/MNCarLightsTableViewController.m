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
#import "MNBLEControlsSegmentsTableViewCell.h"

@interface MNCarLightsTableViewController ()
{
    int indexesOfLightSections[10];
    int numberOfLightsSections;
}

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
    numberOfLightsSections = 0;
    NSArray *commandSectionNames = [MNBluetoothManager commandSectionNames];
    for(int i = 0; i < [commandSectionNames count]; i ++)
    {
        NSRange lightRange = [commandSectionNames[i] rangeOfString:@"Light"];
        if(lightRange.location != NSNotFound)
        {
            indexesOfLightSections[numberOfLightsSections] = i;
            numberOfLightsSections ++;
        }
    }
    
    return numberOfLightsSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *commandSectionDictionaryArrays = [MNBluetoothManager commandSectionDictionaryArrays];
    
    int commandSectionIndex = indexesOfLightSections[section];
    
    return [commandSectionDictionaryArrays[commandSectionIndex] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int commandSectionIndex = indexesOfLightSections[section];
    
    return [[MNBluetoothManager commandSectionNames] objectAtIndex:commandSectionIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *commandSectionDictionaryArrays = [MNBluetoothManager commandSectionDictionaryArrays];
    int commandSectionIndex = indexesOfLightSections[indexPath.section];
    
    if([[[[commandSectionDictionaryArrays objectAtIndex:commandSectionIndex] objectAtIndex:indexPath.row] objectForKey:@"title"] isEqualToString:@"Headlights"])
    {
        MNBLEControlsSegmentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"segmentsCell" forIndexPath:indexPath];
        NSDictionary *commandDictionaryForCell = [[commandSectionDictionaryArrays objectAtIndex:commandSectionIndex] objectAtIndex:indexPath.row];
        
        [cell setCommandDictionary:commandDictionaryForCell];
        
        return cell;
    }
    else
    {
        MNCarToggleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToggleCell" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.label.text = [[[commandSectionDictionaryArrays objectAtIndex:commandSectionIndex] objectAtIndex:indexPath.row] objectForKey:@"title"];
        
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
