//
//  MNCarNavigationController.m
//  BLECarTesting
//
//  Created by James Adams on 4/21/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarNavigationController.h"
#import "MNBluetoothManager.h"

@interface MNCarNavigationController ()

@end

@implementation MNCarNavigationController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BLEConnectionStatusChange:) name:@"BLEConnectionStatusChange" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)BLEConnectionStatusChange:(NSNotification *)notification
{
    NSLog(@"Conneciton status change");
    
    if([notification.object integerValue] == ConnectionStatusConnected)
    {
        [self.navigationBar setBarTintColor:[UIColor whiteColor]]; // greenColor
    }
    else if([notification.object integerValue] == ConnectionStatusScanning)
    {
        [self.navigationBar setBarTintColor:[UIColor redColor]]; // blueColor
    }
    else if([notification.object integerValue] == ConnectionStatusDisconnected)
    {
        [self.navigationBar setBarTintColor:[UIColor redColor]];
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
