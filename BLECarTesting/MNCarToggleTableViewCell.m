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
        self.shouldSendFactoryCommand = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    self.shouldSendFactoryCommand = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandStateChanged:) name:@"CommandStateChanged" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleSwitchChange:(id)sender
{
    if(self.command[@"factoryCharacter"] != nil && self.shouldSendFactoryCommand)
    {
        [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withFactoryState:(self.toggleSwitch.isOn ? 1 : 0)];
    }
    else
    {
        [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withState:(self.toggleSwitch.isOn ? 1 : 0)];
    }
}

- (void)commandStateChanged:(NSNotification *)notification
{
    if(self.command == notification.userInfo[@"command"])
    {
        self.command = notification.userInfo[@"command"];
    }
}

- (void)setCommand:(NSMutableDictionary *)command
{
    _command = command;
    
    if([self.command[@"currentState"] integerValue])
    {
        [self.toggleSwitch setOn:YES animated:YES];
    }
    else
    {
        [self.toggleSwitch setOn:NO animated:YES];
    }
    
    // Update the label
    self.label.text = [self.command objectForKey:@"title"];
}

@end
