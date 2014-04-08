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

@interface MNCarBLEViewController : UIViewController <CBCentralManagerDelegate, UARTPeripheralDelegate, UITextFieldDelegate>
{
    
}

- (IBAction)connectDisconnectButtonPress:(id)sender;
- (IBAction)sendButtonPress:(id)sender;
- (IBAction)clearTextViewButtonPress:(id)sender;
- (IBAction)doSomethingWithCarButtonPress:(id)sender;

@property(nonatomic, assign) ConnectionStatus connectionStatus;

@property(strong, nonatomic) IBOutlet UIButton *connectDisconnectButton;
@property(strong, nonatomic) IBOutlet UIButton *sendButton;
@property(strong, nonatomic) IBOutlet UITextField *sendTextField;
@property(strong, nonatomic) IBOutlet UITextView *receivedTextView;
@property(strong, nonatomic) IBOutlet UIButton *clearTextViewButton;
@property(strong, nonatomic) IBOutlet UIButton *doSomethingWithCarButton;

@end
