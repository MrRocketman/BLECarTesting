//
//  MNUserTabIgnitionViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/18/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarIgnitionViewController.h"
#import "YHRoundBorderedButton.h"
#import "MNBluetoothManager.h"

@interface MNCarIgnitionViewController ()

@end

@implementation MNCarIgnitionViewController

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
    
    // Set the ignitionButton data
    self.ignitionButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Ignition"];
    self.ignitionButton.buttonPressedCommandState = 2;
    
    // Set the battery data
    self.batteryButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Ignition"];
    self.batteryButton.buttonPressedCommandState = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ignitionButtonPress:(id)sender
{
    if(self.batteryButton.isHighlighted)
    {
        // Push the battery button, but tell it not to send a command when it is released
        self.batteryButton.buttonNormalCommandState = -999;
        [self.batteryButton buttonPressed:NO];
        self.batteryButton.buttonNormalCommandState = 0;
    }
    
    if(self.ignitionButton.isOn)
    {
        self.batteryButton.hidden = YES;
    }
    else
    {
        self.batteryButton.hidden = NO;
    }
}

- (IBAction)batteryButtonPress:(id)sender
{
    if(self.ignitionButton.isHighlighted && sender != nil)
    {
        // Push the ignition button, but tell it not to send a command when it is released
        self.ignitionButton.buttonNormalCommandState = -999;
        [self.ignitionButton buttonPressed:NO];
        self.ignitionButton.buttonNormalCommandState = 0;
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
