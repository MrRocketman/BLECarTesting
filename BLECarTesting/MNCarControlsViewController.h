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

@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *trunkButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *exhaustButton;

@end
