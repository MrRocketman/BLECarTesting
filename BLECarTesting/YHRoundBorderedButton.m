//
//  YHRoundBorderedButton.m
//  YHRoundBorderedButton
//
//  Created by Yeonghoon Park on 4/10/14.
//  Copyright (c) 2014 yhpark.co. All rights reserved.
//

#import "YHRoundBorderedButton.h"

@interface YHRoundBorderedButton()

@property(nonatomic, assign) BOOL plusIconVisible;
@property(assign, nonatomic) BOOL isOn;
@property(assign, nonatomic) BOOL touchBegan;
@property(assign, nonatomic) BOOL touchEnded;

@end

@implementation YHRoundBorderedButton

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setBorderWidth:(float)borderWidth
{
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = borderWidth;
}

- (void)setIsCircleButton:(BOOL)isCircleButton
{
    _isCircleButton = isCircleButton;
    
    if(isCircleButton)
    {
        self.layer.cornerRadius = self.frame.size.width / 2.0;
    }
    else
    {
        self.layer.cornerRadius = 3.5;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setTitleColor:[self tintColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //[self.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    self.isCircleButton = NO;
    self.borderWidth = 1.0;
    [self refreshBorderColor];
}

- (void)setPlusIconVisibility:(BOOL)show
{
    self.plusIconVisible = show;
    
    // TODO
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self setTitleColor:tintColor forState:UIControlStateNormal];
    [self refreshBorderColor];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self refreshBorderColor];
}

- (void)refreshBorderColor
{
    self.layer.borderColor = [self isEnabled] ? [[self tintColor] CGColor] : [[UIColor grayColor] CGColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [UIView animateWithDuration:0.25f animations:^{
        if(self.isToggleButton)
        {
            if(self.touchBegan && self.isOn)
            {
                self.layer.backgroundColor = [[self tintColor] CGColor];
                self.touchBegan = NO;
            }
            if(self.touchEnded && !self.isOn)
            {
                self.layer.backgroundColor = [[UIColor clearColor] CGColor];
                self.touchEnded = NO;
            }
        }
        else
        {
            
            self.layer.backgroundColor = highlighted ? [[self tintColor] CGColor] : [[UIColor clearColor] CGColor];
        }
    }];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize org = [super sizeThatFits:self.bounds.size];
    return CGSizeMake(org.width + 20, org.height - 2);
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if(self.isToggleButton)
    {
        self.isOn = !self.isOn;
        self.touchBegan = YES;
        self.highlighted = self.isOn;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if(self.isToggleButton)
    {
        self.touchEnded = YES;
        self.highlighted = self.isOn;
    }
}

@end