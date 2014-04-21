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
    
    [UIView animateWithDuration:0.25 animations:^{
        self.rightTopButton.alpha = 1.0;
        self.rightUpButton.alpha = 1.0;
        self.rightDownButton.alpha = 1.0;
        self.rightBottomButton.alpha = 1.0;
    }];
    
    double delayInMilliseconds = 250;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliseconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.rightTopButton.hidden = NO;
        self.rightUpButton.hidden = NO;
        self.rightDownButton.hidden = NO;
        self.rightBottomButton.hidden = NO;
    });
    
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
    
    [UIView animateWithDuration:0.25 animations:^{
        self.rightTopButton.alpha = 0.0;
        self.rightUpButton.alpha = 0.0;
        self.rightDownButton.alpha = 0.0;
        self.rightBottomButton.alpha = 0.0;
    }];
    
    double delayInMilliseconds = 250;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliseconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.rightTopButton.hidden = YES;
        self.rightUpButton.hidden = YES;
        self.rightDownButton.hidden = YES;
        self.rightBottomButton.hidden = YES;
    });
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
