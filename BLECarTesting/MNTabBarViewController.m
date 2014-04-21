//
//  MNTabBarViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/20/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNTabBarViewController.h"
#import "MNBluetoothManager.h"
#import "MNBLETerminalViewController.h"

@interface MNTabBarViewController ()

@end

@implementation MNTabBarViewController

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
    
    // Load the terminal view and set it as the console delegate
    MNBLETerminalViewController *terminalViewController = (MNBLETerminalViewController *)[[self viewControllers] objectAtIndex:2];
    [terminalViewController loadView];
    [[MNBluetoothManager sharedBluetoothManager] setConsoleDelegate:terminalViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
