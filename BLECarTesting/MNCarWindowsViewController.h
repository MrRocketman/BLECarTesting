//
//  MNCarWindowsViewController.h
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHRoundBorderedButton;

@interface MNCarWindowsViewController : UIViewController

@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *leftUpButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *leftDownButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *leftTopButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *leftBottomButton;

@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *rightUpButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *rightDownButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *rightTopButton;
@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *rightBottomButton;

@property(strong, nonatomic) IBOutlet YHRoundBorderedButton *bothButton;

- (IBAction)bothButtonChanged:(id)sender;

@end
