//
//  MNFirstViewController.h
//  BLECarTesting
//
//  Created by James Adams on 4/1/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MNBluetoothManager.h"

@interface MNBLETerminalViewController : UIViewController <UITextFieldDelegate, MNBluetoothManagerConsoleDelegate>

- (IBAction)sendButtonPress:(id)sender;
- (IBAction)clearTextViewButtonPress:(id)sender;

@property(strong, nonatomic) IBOutlet UIButton *sendButton;
@property(strong, nonatomic) IBOutlet UITextField *sendTextField;
@property(strong, nonatomic) IBOutlet UITextView *consoleTextView;
@property(strong, nonatomic) IBOutlet UIButton *clearTextViewButton;


@end
