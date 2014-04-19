//
//  MNBluetoothManager.h
//  BLECarTesting
//
//  Created by James Adams on 4/16/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UARTPeripheral.h"

// Connection status enum
typedef enum
{
    ConnectionStatusDisconnected = 0,
    ConnectionStatusScanning,
    ConnectionStatusConnected,
} ConnectionStatus;

// Protocol definition
@protocol MNBluetoothManagerConsoleDelegate <NSObject>
@required
- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color;
@end


// Main interface
@interface MNBluetoothManager : NSObject <CBCentralManagerDelegate, UARTPeripheralDelegate>

// Singleton instance declaration
+ (id)sharedBluetoothManager;

// Console Delegate declaration
@property(strong, nonatomic) id <MNBluetoothManagerConsoleDelegate> consoleDelegate;
@property(readonly, nonatomic) NSArray *commandSectionNames;
@property(readonly, nonatomic) NSArray *commandSectionDictionaryArrays;

// Public methods
- (void)writeStringToArduino:(NSString *)string;
- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color;
- (void)writeDebugStringToConsole:(NSString *)string;

@end
