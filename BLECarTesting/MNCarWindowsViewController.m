//
//  MNCarWindowsViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarWindowsViewController.h"
#import "YHRoundBorderedButton.h"
#import "MNBluetoothManager.h"

@interface MNCarWindowsViewController ()
{
    float originalLeftButtonsCenterX;
    float originalRightButtonsCenterX;
    float originalLeftLabelCenterX;
    float originalRightLabelCenterX;
}

@end

@implementation MNCarWindowsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    originalLeftButtonsCenterX = self.leftTopButton.center.x;
    originalRightButtonsCenterX = self.rightTopButton.center.x;
    originalLeftLabelCenterX = self.leftLabel.center.x;
    originalRightLabelCenterX = self.rightLabel.center.x;
    
    [self setSingleWindowCommands];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSingleWindowCommands
{
    self.leftTopButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Left Window"];
    self.leftTopButton.buttonPressedCommandState = 0;
    self.leftTopButton.buttonNormalCommandState = -999;
    self.leftUpButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Left Window Move"];
    self.leftDownButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Left Window Move"];
    self.leftDownButton.buttonPressedCommandState = 2;
    self.leftBottomButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Left Window"];
    self.leftBottomButton.buttonPressedCommandState = 1;
    self.leftBottomButton.buttonNormalCommandState = -999;
    
    // Move the buttons apart
    [UIView animateWithDuration:0.50 animations:^{
        self.leftLabel.alpha = 1.0;
        self.rightLabel.alpha = 1.0;
        
        self.rightTopButton.alpha = 1.0;
        self.rightUpButton.alpha = 1.0;
        self.rightDownButton.alpha = 1.0;
        self.rightBottomButton.alpha = 1.0;
        self.rightTopButton.enabled = YES;
        self.rightUpButton.enabled = YES;
        self.rightDownButton.enabled = YES;
        self.rightBottomButton.enabled = YES;
        
        CGPoint newCenterPoint = self.rightLabel.center;
        newCenterPoint.x = originalRightLabelCenterX;
        self.rightLabel.center = newCenterPoint;
        
        newCenterPoint = self.leftLabel.center;
        newCenterPoint.x = originalLeftLabelCenterX;
        self.leftLabel.center = newCenterPoint;
        
        newCenterPoint = self.rightTopButton.center;
        newCenterPoint.x = originalRightButtonsCenterX;
        self.rightTopButton.center = newCenterPoint;
        newCenterPoint = self.rightUpButton.center;
        newCenterPoint.x = originalRightButtonsCenterX;
        self.rightUpButton.center = newCenterPoint;
        newCenterPoint = self.rightDownButton.center;
        newCenterPoint.x = originalRightButtonsCenterX;
        self.rightDownButton.center = newCenterPoint;
        newCenterPoint = self.rightBottomButton.center;
        newCenterPoint.x = originalRightButtonsCenterX;
        self.rightBottomButton.center = newCenterPoint;
        
        newCenterPoint = self.leftTopButton.center;
        newCenterPoint.x = originalLeftButtonsCenterX;
        self.leftTopButton.center = newCenterPoint;
        newCenterPoint = self.leftUpButton.center;
        newCenterPoint.x = originalLeftButtonsCenterX;
        self.leftUpButton.center = newCenterPoint;
        newCenterPoint = self.leftDownButton.center;
        newCenterPoint.x = originalLeftButtonsCenterX;
        self.leftDownButton.center = newCenterPoint;
        newCenterPoint = self.leftBottomButton.center;
        newCenterPoint.x = originalLeftButtonsCenterX;
        self.leftBottomButton.center = newCenterPoint;
    }];
    
    self.rightTopButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Right Window"];
    self.rightTopButton.buttonPressedCommandState = 0;
    self.rightTopButton.buttonNormalCommandState = -999;
    self.rightUpButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Right Window Move"];
    self.rightDownButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Right Window Move"];
    self.rightDownButton.buttonPressedCommandState = 2;
    self.rightBottomButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Right Window"];
    self.rightBottomButton.buttonPressedCommandState = 1;
    self.rightBottomButton.buttonNormalCommandState = -999;
}

- (void)setBothWindowsCommands
{
    self.leftTopButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Both Windows"];
    self.leftTopButton.buttonPressedCommandState = 0;
    self.leftTopButton.buttonNormalCommandState = -999;
    self.leftUpButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Both Windows Move"];
    self.leftDownButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Both Windows Move"];
    self.leftDownButton.buttonPressedCommandState = 2;
    self.leftBottomButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Both Windows"];
    self.leftBottomButton.buttonPressedCommandState = 1;
    self.leftBottomButton.buttonNormalCommandState = -999;
    
    // Move the buttons together
    [UIView animateWithDuration:0.25 animations:^{
        self.leftLabel.alpha = 0.0;
        self.rightLabel.alpha = 0.0;
        
        self.rightTopButton.alpha = 0.0;
        self.rightUpButton.alpha = 0.0;
        self.rightDownButton.alpha = 0.0;
        self.rightBottomButton.alpha = 0.0;
        self.rightTopButton.enabled = NO;
        self.rightUpButton.enabled = NO;
        self.rightDownButton.enabled = NO;
        self.rightBottomButton.enabled = NO;
        
        CGPoint newCenterPoint = self.rightLabel.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.rightLabel.center = newCenterPoint;
        
        newCenterPoint = self.leftLabel.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.leftLabel.center = newCenterPoint;
        
        newCenterPoint = self.rightTopButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.rightTopButton.center = newCenterPoint;
        newCenterPoint = self.rightUpButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.rightUpButton.center = newCenterPoint;
        newCenterPoint = self.rightDownButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.rightDownButton.center = newCenterPoint;
        newCenterPoint = self.rightBottomButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.rightBottomButton.center = newCenterPoint;
        
        newCenterPoint = self.leftTopButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.leftTopButton.center = newCenterPoint;
        newCenterPoint = self.leftUpButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.leftUpButton.center = newCenterPoint;
        newCenterPoint = self.leftDownButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.leftDownButton.center = newCenterPoint;
        newCenterPoint = self.leftBottomButton.center;
        newCenterPoint.x = self.bothButton.center.x;
        self.leftBottomButton.center = newCenterPoint;
    }];
}

- (IBAction)bothButtonChanged:(id)sender
{
    if(self.bothButton.isOn)
    {
        [self setBothWindowsCommands];
    }
    else
    {
        [self setSingleWindowCommands];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
