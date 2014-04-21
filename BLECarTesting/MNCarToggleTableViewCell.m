//
//  MNCarToggleTableViewCell.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarToggleTableViewCell.h"
#import "MNBluetoothManager.h"

@implementation MNCarToggleTableViewCell

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

- (IBAction)toggleSwitchChange:(id)sender
{
    if(self.command[@"factoryCommand"] != nil)
    {
        [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withFactoryState:(self.toggleSwitch.isOn ? 1 : 0)];
    }
    else
    {
        [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withState:(self.toggleSwitch.isOn ? 1 : 0)];
    }
}

- (void)setCommand:(NSDictionary *)command
{
    _command = command;
    
    // Update the label
    self.label.text = [self.command objectForKey:@"title"];
}

@end
