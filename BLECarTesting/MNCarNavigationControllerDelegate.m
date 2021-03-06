//
//  MNCarNavigationControllerDelegate.m
//  BLECarTesting
//
//  Created by James Adams on 4/24/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarNavigationControllerDelegate.h"
#import "MNBluetoothManager.h"

@interface MNCarNavigationControllerDelegate()

@property(strong, nonatomic) NSMutableDictionary *doorLockCommand;
@property(strong, nonatomic) UIBarButtonItem *doorLockStatusItem;

@end


@implementation MNCarNavigationControllerDelegate

- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandStateChanged:) name:@"CommandStateChanged" object:nil];
        
        self.doorLockStatusItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Locked"] style:UIBarButtonItemStyleBordered target:nil action:nil];
        
        self.doorLockCommand = [[MNBluetoothManager sharedBluetoothManager] commandForCommandTitle:@"Locks"];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commandStateChanged:(NSNotification *)notification
{
    NSMutableDictionary *command = notification.userInfo[@"command"];
    
    if(command == self.doorLockCommand)
    {
        self.doorLockCommand = command;
    }
}

- (void)setDoorLockCommand:(NSMutableDictionary *)doorLockCommand
{
    _doorLockCommand = doorLockCommand;
    
    if([doorLockCommand[@"currentState"] integerValue])
    {
        self.doorLockStatusItem.image = [UIImage imageNamed:@"Unlocked"];
    }
    else
    {
        self.doorLockStatusItem.image = [UIImage imageNamed:@"Locked"];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.rightBarButtonItem = self.doorLockStatusItem;
}

@end
