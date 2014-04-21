//
//  MNUserTabIgnitionViewController.h
//  BLECarTesting
//
//  Created by James Adams on 4/18/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHRoundBorderedButton;

@interface MNCarIgnitionViewController : UIViewController

@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *ignitionButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *batteryButton;

- (IBAction)ignitionButtonPress:(id)sender; // Need this action so we can toggle the battery button
- (IBAction)batteryButtonPress:(id)sender; // Need this action so we can toggle the ignition button

@end
