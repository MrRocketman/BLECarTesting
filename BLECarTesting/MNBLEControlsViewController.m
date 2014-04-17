//
//  MNSecondViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/1/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNBLEControlsViewController.h"
#import "MNBluetoothManager.h"

@interface MNBLEControlsViewController ()

@end

@implementation MNBLEControlsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)headlightsSegmentedControlChange:(id)sender
{
    if([self.headlightsSegmentedControl selectedSegmentIndex] == 0)
    {
        [[MNBluetoothManager sharedBluetoothManager] writeStringToArduino:@"C101 S2"];
    }
    else if([self.headlightsSegmentedControl selectedSegmentIndex] == 1)
    {
        [[MNBluetoothManager sharedBluetoothManager] writeStringToArduino:@"C101 S1"];
    }
    else if([self.headlightsSegmentedControl selectedSegmentIndex] == 2)
    {
        [[MNBluetoothManager sharedBluetoothManager] writeStringToArduino:@"C101 S0"];
    }
}

@end
