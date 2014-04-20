//
//  MNCarSegmentsTableViewCell.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarSegmentsTableViewCell.h"

@implementation MNCarSegmentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions

- (IBAction)segmentedControlValueChanged:(id)sender
{
    //[[MNBluetoothManager sharedBluetoothManager] writeStringToArduino:@"C101 S2"];
    
    // String format: C01 S2
    //[[MNBluetoothManager sharedBluetoothManager] writeStringToArduino:[NSString stringWithFormat:@"%@ %@%d", [self.commandDictionary objectForKey:@"baseCommand"], [self.commandDictionary objectForKey:@"stateCommand"], (int)[sender selectedSegmentIndex]]];
}

#pragma mark - Public Methods

- (void)setCommandDictionary:(NSDictionary *)commandDictionary
{
    _commandDictionary = commandDictionary;
    
    // Update the segmented control
    [self.segmentedControl removeAllSegments];
    for(int i = 0; i < [[self.commandDictionary objectForKey:@"numberOfStates"] integerValue]; i ++)
    {
        [self.segmentedControl insertSegmentWithTitle:[[self.commandDictionary objectForKey:@"stateLabels"] objectAtIndex:i] atIndex:i animated:NO];
    }
    
    // Update the label
    self.label.text = [self.commandDictionary objectForKey:@"title"];
}

@end
