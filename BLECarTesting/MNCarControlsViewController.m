//
//  MNCarControlsViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/19/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarControlsViewController.h"
#import "YHRoundBorderedButton.h"
#import "MNBluetoothManager.h"

@interface MNCarControlsViewController ()

@end

@implementation MNCarControlsViewController

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
    
    self.trunkButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Trunk"];
    self.trunkButton.buttonPressedCommandState = 1;
    self.trunkButton.buttonNormalCommandState = 2;
    self.exhaustButton.command = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Exhaust"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)musicButtonPress:(id)sender
{
    NSString *stringURL = @"music:";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
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
