//
//  MNBLEControlsSegmentsTableViewCell.h
//  BLECarTesting
//
//  Created by James Adams on 4/16/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

// Example of a command dictionary
/*NSDictionary *section5Command4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"C203" @"baseCommand",
                                  @2, @"numberOfStates",
                                  @[@"Off", @"On"], @"stateLabels",
                                  @"S", @"stateCommand",
                                  @"F", @"factoryCommand",
                                  @"Dome", @"title",
                                  @"Interior Lights", @"category",
                                  nil];*/

#import <UIKit/UIKit.h>

@interface MNBLEControlsSegmentsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl2;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property(strong, nonatomic) NSDictionary *commandDictionary;

- (IBAction)segmentedControlValueChanged:(id)sender;
- (IBAction)segmentedControl2ValueChanged:(id)sender;

- (void)updateCell;

@end
