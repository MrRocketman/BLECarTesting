//
//  YHRoundBorderedButton.h
//  YHRoundBorderedButton
//
//  Created by Yeonghoon Park on 4/10/14.
//  Copyright (c) 2014 yhpark.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRoundBorderedButton : UIButton

@property(assign, nonatomic) int buttonPressedCommandState;
@property(assign, nonatomic) int buttonNormalCommandState;
@property(readwrite, nonatomic) NSDictionary *command;

@property(assign, nonatomic) BOOL isToggleButton;
@property(assign, nonatomic) BOOL isCircleButton;
@property(assign, nonatomic) float borderWidth;

- (void)setPlusIconVisibility:(BOOL)show;

@end
