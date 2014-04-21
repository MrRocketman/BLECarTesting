//
//  MNCarSegmentsTableViewCell.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarSegmentsTableViewCell.h"
#import "MNBluetoothManager.h"

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
    [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withState:(int)[self.segmentedControl selectedSegmentIndex]];
}

#pragma mark - Public Methods

- (void)setCommand:(NSDictionary *)command
{
    _command = command;
    
    // Update the segmented control
    [self.segmentedControl removeAllSegments];
    for(int i = 0; i < [[self.command objectForKey:@"numberOfStates"] integerValue]; i ++)
    {
        [self.segmentedControl insertSegmentWithTitle:[[self.command objectForKey:@"stateLabels"] objectAtIndex:i] atIndex:i animated:NO];
    }
    
    // Update the label
    self.label.text = [self.command objectForKey:@"title"];
}

@end
