//
//  MNFirstViewController.h
//  BLECarTesting
//
//  Created by James Adams on 4/1/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UARTPeripheral.h"

typedef enum
{
    ConnectionStatusDisconnected = 0,
    ConnectionStatusScanning,
    ConnectionStatusConnected,
} ConnectionStatus;

@interface MNCarBLEViewController : UIViewController <CBCentralManagerDelegate, UARTPeripheralDelegate>
{
    
}

- (IBAction)connectDisconnectButtonPress:(id)sender;

@property(nonatomic, assign) ConnectionStatus connectionStatus;
@property(strong, nonatomic) IBOutlet UIButton *connectDisconnectButton;

@end