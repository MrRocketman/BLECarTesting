//
//  YHRoundBorderedButton.m
//  YHRoundBorderedButton
//
//  Created by Yeonghoon Park on 4/10/14.
//  Copyright (c) 2014 yhpark.co. All rights reserved.
//

#import "YHRoundBorderedButton.h"
#import "MNBluetoothManager.h"

@interface YHRoundBorderedButton()

@property(assign, nonatomic) BOOL isOn;
@property(assign, nonatomic) BOOL touchBegan;
@property(assign, nonatomic) BOOL touchEnded;
@property(assign, nonatomic) BOOL shouldSendCommand;

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

- (void)setCommand:(NSMutableDictionary *)command
{
    _command = command;
    
    self.shouldSendCommand = NO;
    if([self.command[@"currentState"] integerValue] == self.buttonPressedCommandState)
    {
        [self buttonPressed:YES];
    }
    else
    {
        [self buttonPressed:NO];
    }
    self.shouldSendCommand = YES;
}

- (void)commandStateChanged:(NSNotification *)notification
{
    if(self.command == notification.userInfo[@"command"])
    {
        self.command = notification.userInfo[@"command"];
    }
}

- (void)setup
{
    self.buttonPressedCommandState = 1;
    self.buttonNormalCommandState = 0;

    self.shouldSendCommand = YES;
    
    [self setTitleColor:[self tintColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //[self.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    self.isCircleButton = NO;
    self.borderWidth = 1.0;
    [self refreshBorderColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandStateChanged:) name:@"CommandStateChanged" object:nil];
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

- (void)buttonPressed:(BOOL)pressed
{
    if(pressed)
    {
        self.isOn = YES;
        self.touchBegan = YES;
        self.touchEnded = NO;
        self.highlighted = self.isOn;
    }
    else
    {
        self.isOn = NO;
        self.touchEnded = YES;
        self.touchBegan = NO;
        self.highlighted = self.isOn;
    }
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
                
                // send BLE command
                if(self.buttonNormalCommandState != -999 && self.shouldSendCommand)
                {
                    [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withState:self.buttonPressedCommandState];
                }
            }
            if(self.touchEnded && !self.isOn)
            {
                self.layer.backgroundColor = [[UIColor clearColor] CGColor];
                self.touchEnded = NO;
                
                // send BLE command
                if(self.buttonNormalCommandState != -999 && self.shouldSendCommand)
                {
                    [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withState:self.buttonNormalCommandState];
                }
            }
        }
        else
        {
            self.layer.backgroundColor = highlighted ? [[self tintColor] CGColor] : [[UIColor clearColor] CGColor];
            
            // send BLE command
            if(self.buttonNormalCommandState != -999 && self.touchBegan && self.shouldSendCommand)
            {
                [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withState:self.buttonNormalCommandState];
                self.touchBegan = NO;
                self.touchEnded = NO;
            }
            if(self.buttonPressedCommandState != -999 && self.touchEnded && self.shouldSendCommand)
            {
                [[MNBluetoothManager sharedBluetoothManager] writeCommandToArduino:self.command withState:self.buttonPressedCommandState];
                self.touchBegan = NO;
                self.touchEnded = NO;
            }
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
    
    self.touchBegan = YES;
    self.touchEnded = NO;
    if(self.isToggleButton)
    {
        self.isOn = !self.isOn;
        self.highlighted = self.isOn;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.touchBegan = NO;
    self.touchEnded = YES;
    if(self.isToggleButton)
    {
        self.highlighted = self.isOn;
    }
}

@end
