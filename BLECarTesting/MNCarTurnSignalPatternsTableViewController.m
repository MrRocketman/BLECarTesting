//
//  MNCarTurnSignalPatternsTableViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarTurnSignalPatternsTableViewController.h"
#import "MNBluetoothManager.h"

@interface MNCarTurnSignalPatternsTableViewController ()

@property(strong, nonatomic) NSIndexPath *previouslySelectedIndexPath;
@property(strong, nonatomic) NSDictionary *turnSignalPatternsCommand;
@property(strong, nonatomic) NSIndexPath *arduinoPattern;

@end


@implementation MNCarTurnSignalPatternsTableViewController

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
    
    self.turnSignalPatternsCommand = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Turn Signal Patterns"];
    
    // Show the checkmark for the previously selected turn signal pattern
    [self.tableView reloadData];
    NSMutableDictionary *command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Turn Signal Patterns"];
    self.arduinoPattern = [NSIndexPath indexPathForRow:[[command objectForKey:@"currentState"] integerValue] inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:self.arduinoPattern];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.turnSignalPatternsCommand objectForKey:@"numberOfStates"] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.turnSignalPatternsCommand objectForKey:@"stateLabels"] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    [[tableView cellForRowAtIndexPath:self.previouslySelectedIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    
    self.previouslySelectedIndexPath = indexPath;
    
    NSMutableDictionary *command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Turn Signal Patterns"];
    [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:command withState:(int)indexPath.row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Auto pop if the user selects a cell
    if(indexPath != self.arduinoPattern)
    {
        double delayInMilliseconds = 250;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliseconds * NSEC_PER_MSEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
#pragma mark TODO: Segue back to the settings view here
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
