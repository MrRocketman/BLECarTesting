//
//  MNCarToggleTableViewCell.h
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNCarToggleTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property(strong, nonatomic) IBOutlet UILabel *label;

@property(strong, nonatomic) NSDictionary *command;

- (IBAction)toggleSwitchChange:(id)sender;

@end
