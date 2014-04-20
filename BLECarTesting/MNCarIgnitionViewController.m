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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ignitionButtonPress:(id)sender
{
    
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
