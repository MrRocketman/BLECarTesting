//
//  MNCarControlsViewController.h
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHRoundBorderedButton;

@interface MNCarControlsViewController : UIViewController

@property(readwrite, nonatomic) IBOutlet YHRoundBorderedButton *trunkButton;
@property(readwrite, nonatomic) IBOutlet YHRoundBorderedButton *exhaustButton;

@end
