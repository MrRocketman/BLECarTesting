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

- (IBAction)ignitionButtonPress:(id)sender;

@end
