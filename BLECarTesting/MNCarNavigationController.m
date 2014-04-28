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

@property(assign, nonatomic) BOOL isUIEnabled;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIControlSwtichChange:) name:@"UIControlSwitchChange" object:nil];
    self.navigationBar.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)UIControlSwtichChange:(NSNotification *)aNotification
{
    if([aNotification.userInfo[@"isOn"] integerValue])
    {
        self.isUIEnabled = YES;
        
        [self.visibleViewController.view setUserInteractionEnabled:YES];
        NSLog(@"UI Enabled");
    }
    else
    {
        self.isUIEnabled = NO;
        
        NSLog(@"UI Disabled");
    }
}

- (void)BLEConnectionStatusChange:(NSNotification *)notification
{
    BOOL userInterfaceEnabled = NO;
    
    if([notification.object integerValue] == ConnectionStatusConnected)
    {
        NSLog(@"Conneciton status: Connected");
        [self.navigationBar setBarTintColor:[UIColor whiteColor]]; // greenColor
        
        userInterfaceEnabled = YES;
    }
    else if([notification.object integerValue] == ConnectionStatusConnecting)
    {
        NSLog(@"Conneciton status: Connectiing/Finding Services");
        [self.navigationBar setBarTintColor:[UIColor blueColor]];
    }
    else if([notification.object integerValue] == ConnectionStatusScanning)
    {
        NSLog(@"Conneciton status: Scanning");
        [self.navigationBar setBarTintColor:[UIColor redColor]];
    }
    else if([notification.object integerValue] == ConnectionStatusDisconnected)
    {
        NSLog(@"Conneciton status: Disconnected");
        [self.navigationBar setBarTintColor:[UIColor redColor]];
    }
    
    if(!self.isUIEnabled)
    {
        [self.visibleViewController.view setUserInteractionEnabled:userInterfaceEnabled];
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
