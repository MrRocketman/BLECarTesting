//
//  MNBluetoothManager.h
//  BLECarTesting
//
//  Created by James Adams on 4/16/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

// A Command is an NSDictionary like this:
/*NSMutableDictionary *dictionary22 = @{@"baseCommand" : @"C154",
                               @"numberOfStates" : @2,
                               @"stateLabels" : @[@"Close", @"Open"],
                               @"stateCharacter" : @"S",
                               @"dataCharacter" : @"D",
                               @"factoryCharacter" : @"F",
                               @"title" : @"Under Dash",
                               @"category" : @"Interior Lights",
                               @"currentState" : @0};*/

// A commandCategory is an NSString. It comes from the 'category' key of the command

// Connection status enum
typedef enum
{
    ConnectionStatusDisconnected = 0,
    ConnectionStatusScanning,
    ConnectionStatusConnecting,
    ConnectionStatusConnected,
} ConnectionStatus;

// Protocol definition
@protocol MNBluetoothManagerConsoleDelegate <NSObject>
@required
- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color;
@end


// Main interface
@interface MNBluetoothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

// Singleton instance declaration
+ (MNBluetoothManager *)sharedBluetoothManager;

// Console Delegate declaration
@property(strong, nonatomic) id <MNBluetoothManagerConsoleDelegate> consoleDelegate;

@property(readonly, nonatomic) ConnectionStatus connectionStatus;

// Public methods
// CommandCategories
- (NSArray *)commandCategories;
- (NSArray *)commandCategoriesMatchingSearchString:(NSString *)string;
- (NSDictionary *)commandCategoryMatchingSearchString:(NSString *)string;
- (int)indexOfCommandCategory:(NSString *)string;
- (int)commandCategoriesCount;

// All Commands
- (NSArray *)commandDictionariesArray;

// Specific Commands
- (int)indexOfCommandWithTitle:(NSString *)title;
- (NSDictionary *)commandForCommandTitle:(NSString *)title;

// Categories of commands
- (NSArray *)commandsForCategory:(NSString *)category;
- (NSDictionary *)commandForCategory:(NSString *)category atIndex:(int)index;
- (int)commandsCountForCategory:(NSString *)category;

// BLE
- (void)writeCommandToArduino:(NSDictionary *)command withState:(int)state andFactoryState:(int)factory;
- (void)writeCommandToArduino:(NSDictionary *)command withState:(int)state;
- (void)writeCommandToArduino:(NSDictionary *)command withFactoryState:(int)factory;

- (void)writeStringToArduino:(NSString *)string;
- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color;
- (void)writeDebugStringToConsole:(NSString *)string;

@end
