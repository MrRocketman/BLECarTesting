//
//  MNBLEControlsSegmentsTableViewCell.m
//  BLECarTesting
//
//  Created by James Adams on 4/16/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNBLEControlsSegmentsTableViewCell.h"
#import "MNBluetoothManager.h"

@implementation MNBLEControlsSegmentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandStateChanged:) name:@"CommandStateChanged" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commandStateChanged:(NSNotification *)notification
{
    if(self.commandDictionary == notification.userInfo[@"command"])
    {
        self.commandDictionary = notification.userInfo[@"command"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions

- (IBAction)segmentedControlValueChanged:(id)sender
{
    // String format: C01 S2
    [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.commandDictionary withState:(int)[sender selectedSegmentIndex]];
}

- (IBAction)segmentedControl2ValueChanged:(id)sender
{
    // String format: C01 F1
    [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.commandDictionary withFactoryState:(int)[sender selectedSegmentIndex]];
}

#pragma mark - Public Methods

- (void)setCommandDictionary:(NSMutableDictionary *)commandDictionary
{
    _commandDictionary = commandDictionary;
    
    // Update the segmented control
    if(self.segmentedControl)
    {
        [self.segmentedControl removeAllSegments];
        for(int i = 0; i < [[self.commandDictionary objectForKey:@"numberOfStates"] integerValue]; i ++)
        {
            [self.segmentedControl insertSegmentWithTitle:[[self.commandDictionary objectForKey:@"stateLabels"] objectAtIndex:i] atIndex:i animated:NO];
        }
        
        // Update selected segment
        [self.segmentedControl setSelectedSegmentIndex:[self.commandDictionary[@"currentState"] integerValue]];
        
        // Update the label
        self.label.text = self.commandDictionary[@"title"];
    }
    // Update sensor values
    else
    {
        self.textLabel.text = self.commandDictionary[@"title"];
        self.detailTextLabel.text = [NSString stringWithFormat:@"%4ld", [self.commandDictionary[@"currentState"] longValue]];
    }
    
    // Disable interaction for switches
    if(self.commandDictionary[@"stateCharacter"] == nil)
    {
        [self.segmentedControl setEnabled:NO];
    }
    else
    {
        [self.segmentedControl setEnabled:YES];
    }
}

@end
