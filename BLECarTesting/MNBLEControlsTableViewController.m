//
//  MNBLEControlsTableViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/16/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNBLEControlsTableViewController.h"
#import "MNBLEControlsSegmentsTableViewCell.h"

@interface MNBLEControlsTableViewController ()
{
    NSArray *sectionNames;
    NSArray *sectionDictionaryArrays;
}

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
    
    sectionNames = @[@"Locks", @"Ignition", @"Controls", @"Exterior Lights", @"Interior Lights", @"Miscellaneous"];
    
    // Locks
    NSDictionary *section1Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C00", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Lock", @"Unlock"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Door Locks", @"title",
                                         @"Locks", @"category",
                                         nil];
    NSArray *section1Dictionaries = @[section1Dictionary1];
    
    // Ignition
    NSDictionary *section2Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C50", @"baseCommand",
                                         @3, @"numberOfStates",
                                         @[@"Off", @"Battery", @"Start"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Ignition", @"title",
                                         @"Ignition", @"category",
                                         nil];
    NSArray *section2Dictionaries = @[section2Dictionary1];
    
    // Controls
    NSDictionary *section3Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C100", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Close", @"Open"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Trunk", @"title",
                                         @"Controls", @"category",
                                         nil];
    NSDictionary *section3Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C101", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Top", @"Bottom"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Left Window", @"title",
                                         @"Controls", @"category",
                                         nil];
    NSDictionary *section3Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C103", @"baseCommand",
                                         @3, @"numberOfStates",
                                         @[@"Stop", @"Up", @"Down"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Left Window", @"title",
                                         @"Controls", @"category",
                                         nil];
    NSDictionary *section3Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C102", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Top", @"Bottom"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Right Window", @"title",
                                         @"Controls", @"category",
                                         nil];
    
    NSDictionary *section3Dictionary5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C104", @"baseCommand",
                                         @3, @"numberOfStates",
                                         @[@"Stop", @"Up", @"Down"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Right Window", @"title",
                                         @"Controls", @"category",
                                         nil];
    NSDictionary *section3Dictionary6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C105", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Top", @"Bottom"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Both Windows", @"title",
                                         @"Controls", @"category",
                                         nil];
    NSDictionary *section3Dictionary7 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C106", @"baseCommand",
                                         @3, @"numberOfStates",
                                         @[@"Stop", @"Up", @"Down"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Both Windows", @"title",
                                         @"Controls", @"category",
                                         nil];
    NSArray *section3Dictionaries = @[section3Dictionary1, section3Dictionary2, section3Dictionary3, section3Dictionary4, section3Dictionary5, section3Dictionary6, section3Dictionary7];
    
    // Exterior Lights
    NSDictionary *section4Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C150", @"baseCommand",
                                         @3, @"numberOfStates",
                                         @[@"Off", @"Low", @"High"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Headlights", @"title",
                                         @"Exterior Lights", @"category",
                                         nil];
    NSDictionary *section4Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C151", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Fog", @"title",
                                         @"Exterior Lights", @"category",
                                         nil];
    NSDictionary *section4Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C152", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Park", @"title",
                                         @"Exterior Lights", @"category",
                                         nil];
    NSDictionary *section4Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C153", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Backup", @"title",
                                         @"Exterior Lights", @"category",
                                         nil];
    NSDictionary *section4Dictionary5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C154", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Tail Night", @"title",
                                         @"Exterior Lights", @"category",
                                         nil];
    NSDictionary *section4Dictionary6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C155", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"License Plate", @"title",
                                         @"Exterior Lights", @"category",
                                         nil];
    NSArray *section4Dictionaries = @[section4Dictionary1, section4Dictionary2, section4Dictionary3, section4Dictionary4, section4Dictionary5, section4Dictionary6];
    
    // Interior Lights
    NSDictionary *section5Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C200", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"F", @"factoryCommand",
                                         @"Left Pillar", @"title",
                                         @"Interior Lights", @"category",
                                         nil];
    NSDictionary *section5Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C201", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"F", @"factoryCommand",
                                         @"Right Pillar", @"title",
                                         @"Interior Lights", @"category",
                                         nil];
    NSDictionary *section5Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C202", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"F", @"factoryCommand",
                                         @"Center Console", @"title",
                                         @"Interior Lights", @"category",
                                         nil];
    NSDictionary *section5Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C203", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"F", @"factoryCommand",
                                         @"Dome", @"title",
                                         @"Interior Lights", @"category",
                                         nil];
    NSDictionary *section5Dictionary5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C204", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"F", @"factoryCommand",
                                         @"Under Dash", @"title",
                                         @"Interior Lights", @"category",
                                         nil];
    NSArray *section5Dictionaries = @[section5Dictionary1, section5Dictionary2, section5Dictionary3, section5Dictionary4, section5Dictionary5];
    
    // Miscellaneous
    NSDictionary *section6Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C250", @"baseCommand",
                                         @3, @"numberOfStates",
                                         @[@"Slow", @"Medium", @"Fast"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Turn Signal Speed", @"title",
                                         @"Miscellaneous", @"category",
                                         nil];
    NSDictionary *section6Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C251", @"baseCommand",
                                         @5, @"numberOfStates",
                                         @[@"Basic", @"Sequence", @"Chase", @"-Sequence", @"OneByOne"], @"stateLabels",
                                         @"S", @"stateCommand",
                                         @"Turn Signal Pattern", @"title",
                                         @"Miscellaneous", @"category",
                                         nil];
    NSDictionary *section6Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C252", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"L", @"stateCommand",
                                         @"Assitive Lighting", @"title",
                                         @"Miscellaneous", @"category",
                                         nil];
    NSDictionary *section6Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"C253", @"baseCommand",
                                         @2, @"numberOfStates",
                                         @[@"Off", @"On"], @"stateLabels",
                                         @"L", @"stateCommand",
                                         @"Automatic Lighting", @"title",
                                         @"Miscellaneous", @"category",
                                         nil];
    NSArray *section6Dictionaries = @[section6Dictionary1, section6Dictionary2, section6Dictionary3, section6Dictionary4];
    
    sectionDictionaryArrays = @[section1Dictionaries, section2Dictionaries, section3Dictionaries, section4Dictionaries, section5Dictionaries, section6Dictionaries];
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
    return [sectionDictionaryArrays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[sectionDictionaryArrays objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionNames[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commandDictionaryForCell = [[sectionDictionaryArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
    [cell updateCell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commandDictionaryForCell = [[sectionDictionaryArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
