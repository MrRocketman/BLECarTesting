//
//  MNCarToggleTableViewCell.h
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNCarToggleTableViewCell : UITableViewCell

@property(readwrite, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property(readwrite, nonatomic) IBOutlet UILabel *label;

- (IBAction)toggleSwitchChange:(id)sender;

@end
