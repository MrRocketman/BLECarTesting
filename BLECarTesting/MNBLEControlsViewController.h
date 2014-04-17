//
//  MNSecondViewController.h
//  BLECarTesting
//
//  Created by James Adams on 4/1/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNBLEControlsViewController : UIViewController <UIScrollViewDelegate>

@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;

// Controls properties
@property(strong, nonatomic) IBOutlet UISegmentedControl *headlightsSegmentedControl;

// Controls Actions
- (IBAction)headlightsSegmentedControlChange:(id)sender;

@end
