//
//  MNCarSettingsTableViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarSettingsTableViewController.h"
#import "MNBluetoothManager.h"
#import "MNCarToggleTableViewCell.h"
#import "MNCarSegmentsTableViewCell.h"

#define NUMBER_OF_SECTIONS 3
#define LIGHTS_SECTION 0
#define TURN_SIGNAL_SECTION 1
#define SWITCH_SETTINGS_SECTION 2

#define NUMBER_OF_ROWS_IN_LIGHTS_SECTION 2
#define AUTO_LIGHTING_ROW 0
#define ASSITIVE_LIGHTING_ROW 1

#define NUMBER_OF_ROWS_IN_TURN_SIGNAL_SECTION 2
#define TURN_SIGNAL_SPEED_ROW 0
#define TURN_SIGNAL_PATTERN_ROW 1

#define NUMBER_OF_ROWS_IN_SWITCH_SETTINGS_SECTION 1
#define SWITCH_SETTINGS_ROW 0

@interface MNCarSettingsTableViewController ()

@end

@implementation MNCarSettingsTableViewController

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
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == LIGHTS_SECTION)
    {
        return NUMBER_OF_ROWS_IN_LIGHTS_SECTION;
    }
    else if(section == TURN_SIGNAL_SECTION)
    {
        return NUMBER_OF_ROWS_IN_TURN_SIGNAL_SECTION;
    }
    else if(section == SWITCH_SETTINGS_SECTION)
    {
        return NUMBER_OF_ROWS_IN_SWITCH_SETTINGS_SECTION;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == LIGHTS_SECTION)
    {
        return @"Lighting";
    }
    else if(section == TURN_SIGNAL_SECTION)
    {
        return @"Turn Signal";
    }
    else if(section == SWITCH_SETTINGS_SECTION)
    {
        return @"Door Ajar Settings";
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *command;
    
    if(indexPath.section == LIGHTS_SECTION)
    {
        MNCarToggleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToggleCell" forIndexPath:indexPath];
        
        if(indexPath.row == AUTO_LIGHTING_ROW)
        {
            command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Automatic Lighting"];
            
        }
        else if(indexPath.row == ASSITIVE_LIGHTING_ROW)
        {
            command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Assistive Lighting"];
        }
        
        // Configure the cell...
        cell.label.text = [command objectForKey:@"title"];
        
        return cell;
    }
    else if(indexPath.section == TURN_SIGNAL_SECTION)
    {
        if(indexPath.row == TURN_SIGNAL_SPEED_ROW)
        {
            MNCarSegmentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentsCell" forIndexPath:indexPath];
            
            command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Turn Signal Speed"];
            
            // Configure the cell...
            [cell setCommandDictionary:command];
            
            return cell;
        }
        else if(indexPath.row == TURN_SIGNAL_PATTERN_ROW)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TurnSignalPatternsCell" forIndexPath:indexPath];
            
            return cell;
        }
    }
    else if(indexPath.section == SWITCH_SETTINGS_SECTION)
    {
        if(indexPath.row == SWITCH_SETTINGS_ROW)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchSettingsCell" forIndexPath:indexPath];
            
            return cell;
        }
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
