//
//  MNUserTabIgnitionViewController.h
//  BLECarTesting
//
//  Created by James Adams on 4/18/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNCarIgnitionViewController : UIViewController

@property(strong, nonatomic) IBOutlet UIButton *ignitionButton;

- (IBAction)ignitionButtonPress:(id)sender;

@end
