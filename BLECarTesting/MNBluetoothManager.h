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
/*NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"C154", @"baseCommand",
                              @2, @"numberOfStates",
                              @[@"Off", @"On"], @"stateLabels",
                              @"S", @"stateCommand",
                              @"F", @"factoryCommand",
                              @"Under Dash", @"title",
                              @"Interior Lights", @"category",
                              nil];*/

// A commandCategory is an NSString. It comes from the 'category' key of the command

// Connection status enum
typedef enum
{
    ConnectionStatusDisconnected = 0,
    ConnectionStatusScanning = 1,
    ConnectionStatusConnected = 2,
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
