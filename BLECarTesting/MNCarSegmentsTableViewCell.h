//
//  MNCarSegmentsTableViewCell.h
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

// Example of a command dictionary
/*NSDictionary *section5Command4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"C203" @"baseCommand",
                                  @2, @"numberOfStates",
                                  @[@"Off", @"On"], @"stateLabels",
                                  @"S", @"stateCommand",
                                  @"F", @"factoryCommand",
                                  @"Dome", @"title",
                                  nil];*/

@interface MNCarSegmentsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property(strong, nonatomic) NSDictionary *command;

@end
