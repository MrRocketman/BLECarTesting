//
//  MNCarSegmentsTableViewCell.h
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

// Example of a command dictionary
/*NSMutableDictionary *dictionary22 = @{@"baseCommand" : @"C154",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Close", @"Open"],
                                      @"stateCharacter" : @"S",
                                      @"dataCharacter" : @"D",
                                      @"factoryCharacter" : @"F",
                                      @"title" : @"Under Dash",
                                      @"category" : @"Interior Lights",
                                      @"currentState" : @0};*/

@interface MNCarSegmentsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property(strong, nonatomic) NSMutableDictionary *command;

@end
