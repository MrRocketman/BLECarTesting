//
//  YHRoundBorderedButton.h
//  YHRoundBorderedButton
//
//  Created by Yeonghoon Park on 4/10/14.
//  Copyright (c) 2014 yhpark.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRoundBorderedButton : UIButton

@property(assign, nonatomic) int buttonPressedCommandState; // Set to -999 to disable command sending
@property(assign, nonatomic) int buttonNormalCommandState; // Set to -999 to disable command sending
@property(strong, nonatomic) NSDictionary *command;

@property(assign, nonatomic) BOOL isToggleButton;
@property(assign, nonatomic) BOOL isCircleButton;
@property(assign, nonatomic) float borderWidth;


@property(readonly, nonatomic) BOOL isOn;
- (void)buttonPressed:(BOOL)pressed;

@end
