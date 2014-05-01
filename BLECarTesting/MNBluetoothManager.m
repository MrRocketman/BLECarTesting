//
//  MNBluetoothManager.m
//  BLECarTesting
//
//  Created by James Adams on 4/16/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNBluetoothManager.h"
#import "NSString+hex.h"
#import "NSData+hex.h"
#import "CBUUID+StringExtraction.h"

#define UART_SERVICE_UUID [CBUUID UUIDWithString:@"6e400001-b5a3-f393-e0a9-e50e24dcca9e"]
#define TX_CHARACTERISTIC_UUID [CBUUID UUIDWithString:@"6e400002-b5a3-f393-e0a9-e50e24dcca9e"]
#define RX_CHARACTERISTIC_UUID [CBUUID UUIDWithString:@"6e400003-b5a3-f393-e0a9-e50e24dcca9e"]

#define DEVICE_INFORMATION_SERVICE_UUID [CBUUID UUIDWithString:@"180A"]
#define HARDWARE_REVISION_STRING_UUID [CBUUID UUIDWithString:@"2A27"]


@interface MNBluetoothManager()

@property(assign, nonatomic) ConnectionStatus connectionStatus;

@property CBCentralManager *centralBluetoothManager;
@property CBPeripheral *bluetoothPeripheral;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;

@property NSMutableString *bufferToWriteToArduino;

@property(strong, nonatomic) NSArray *commandDictionariesArray;
@property(strong, nonatomic) NSArray *commandCategories;

@property(assign, nonatomic) BOOL isRestoringFromBackground;

@property(strong, nonatomic) NSTimer *rssiTimer;
@property(strong, nonatomic) NSNumber *currentRSSI;

@end


@implementation MNBluetoothManager

@synthesize consoleDelegate;

#pragma mark - Init Methods

+ (MNBluetoothManager *)sharedBluetoothManager
{
    static MNBluetoothManager *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}

- (id)init
{
    if(self = [super init])
    {
        self.centralBluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey : @"MNCenterBluetoothManager"}];
        self.connectionStatus = ConnectionStatusDisconnected;
        self.bufferToWriteToArduino = [[NSMutableString alloc] init];
        
        NSDictionary *dictionary;
        NSMutableDictionary *mDictionary;
        NSMutableArray *tempCommandDictionariesArray = [NSMutableArray new];
        
        // Ignition
        dictionary = @{@"baseCommand" : @"C00",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Off", @"Battery", @"Start"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Ignition",
                       @"category" : @"Ignition",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        
        // Controls
        dictionary = @{@"baseCommand" : @"C50",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Lock", @"Unlock"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Door Locks",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C51",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Stop", @"Open", @"Close"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Trunk",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C52",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Stop", @"Top", @"Bottom"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Left Window",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C53",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Stop", @"Top", @"Bottom"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Right Window",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C54",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Stop", @"Up", @"Down"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Left Window Move",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C55",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Stop", @"Up", @"Down"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Right Window Move",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C56",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Stop", @"Top", @"Bottom"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Both Windows",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C57",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Stop", @"Up", @"Down"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Both Windows Move",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C58",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Close", @"Open"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Exhaust Cutouts",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C204",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Horn",
                       @"category" : @"Controls",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        
        // Exterior Lights
        dictionary = @{@"baseCommand" : @"C100",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Off", @"Low", @"High"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Headlights",
                       @"category" : @"Exterior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C101",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Fog",
                       @"category" : @"Exterior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C102",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Parking",
                       @"category" : @"Exterior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C103",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Backup",
                       @"category" : @"Exterior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C104",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Tail Dims",
                       @"category" : @"Exterior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C106",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Emergency Flahsers",
                       @"category" : @"Exterior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C107",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Off", @"Right", @"Left"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Turn Signals",
                       @"category" : @"Exterior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        
        // Interior Lights
        dictionary = @{@"baseCommand" : @"C150",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"factoryCharacter" : @"F",
                       @"factoryState" : @0,
                       @"title" : @"Left Pillar",
                       @"category" : @"Interior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C151",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"factoryCharacter" : @"F",
                       @"factoryState" : @0,
                       @"title" : @"Right Pillar",
                       @"category" : @"Interior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C152",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"factoryCharacter" : @"F",
                       @"factoryState" : @0,
                       @"title" : @"Center Console",
                       @"category" : @"Interior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C153",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"factoryCharacter" : @"F",
                       @"factoryState" : @0,
                       @"title" : @"Dome",
                       @"category" : @"Interior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C154",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"factoryCharacter" : @"F",
                       @"factoryState" : @0,
                       @"title" : @"Under Dash",
                       @"category" : @"Interior Lights",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        
        // Miscellaneous
        dictionary = @{@"baseCommand" : @"C200",
                       @"numberOfStates" : @3,
                       @"stateLabels" : @[@"Slow", @"Medium", @"Fast"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Turn Signal Speed",
                       @"category" : @"Miscellaneous",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C201",
                       @"numberOfStates" : @5,
                       @"stateLabels" : @[@"Basic", @"Sequence", @"Chase", @"-Sequence", @"OneByOne"],
                       @"stateCharacter" : @"S",
                       @"dataCharacter" : @"D",
                       @"title" : @"Turn Signal Patterns",
                       @"category" : @"Miscellaneous",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C202",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"L",
                       @"dataCharacter" : @"D",
                       @"title" : @"Assistive Lighting",
                       @"category" : @"Miscellaneous",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C203",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"Off", @"On"],
                       @"stateCharacter" : @"A",
                       @"dataCharacter" : @"D",
                       @"title" : @"Automatic Lighting",
                       @"category" : @"Miscellaneous",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        
        // Sensor Data
        dictionary = @{@"baseCommand" : @"C300",
                       @"dataCharacter" : @"D",
                       @"title" : @"Trunk Amps",
                       @"category" : @"Sensors",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C301",
                       @"dataCharacter" : @"D",
                       @"title" : @"Left Window Amps",
                       @"category" : @"Sensors",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C302",
                       @"dataCharacter" : @"D",
                       @"title" : @"Right Window Amps",
                       @"category" : @"Sensors",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C303",
                       @"dataCharacter" : @"D",
                       @"title" : @"Alternator Amps",
                       @"category" : @"Sensors",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C304",
                       @"dataCharacter" : @"D",
                       @"title" : @"Light Sensor",
                       @"category" : @"Sensors",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        
        // Switches
        dictionary = @{@"baseCommand" : @"C205",
                       @"dataCharacter" : @"D",
                       @"numberOfStates" : @4,
                       @"stateLabels" : @[@"Closed", @"Right", @"Left", @"Both"],
                       @"title" : @"Door Ajar",
                       @"category" : @"Switches",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        dictionary = @{@"baseCommand" : @"C206",
                       @"dataCharacter" : @"D",
                       @"numberOfStates" : @2,
                       @"stateLabels" : @[@"In Gear", @"In Park"],
                       @"title" : @"Neutral Safety Switch",
                       @"category" : @"Switches",
                       @"currentState" : @0};
        mDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [tempCommandDictionariesArray addObject:mDictionary];
        
        self.commandDictionariesArray = (NSArray *)tempCommandDictionariesArray;
        
        // Set this here because the ordering of the array is not guaranteed. Thus we can't do this calculation every time someone asks for it. Otherwise the data we would be sending them would be all over the place.
        //self.commandCategories = [self.commandDictionariesArray valueForKeyPath:@"distinctUnionOfObjects.category"];
        
        // Determine the command categories
        NSMutableArray *unique = [NSMutableArray array];
        NSMutableSet *processed = [NSMutableSet set];
        for(int i = 0; i < self.commandDictionariesArray.count; i ++)
        {
            NSString *category = self.commandDictionariesArray[i][@"category"];
            if ([processed containsObject:category] == NO)
            {
                [unique addObject:category];
                [processed addObject:category];
            }
        }
        self.commandCategories = (NSArray *)unique;
    }
    return self;
}

#pragma mark - Public Command Methods

- (NSArray *)commandCategories
{
    return _commandCategories;
}

- (NSArray *)commandCategoriesMatchingSearchString:(NSString *)string
{
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", string];
    
    NSArray *filteredCategories = [self.commandCategories filteredArrayUsingPredicate:filter];
    
    return filteredCategories;
}

- (NSDictionary *)commandCategoryMatchingSearchString:(NSString *)string
{
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", string];
    
    NSArray *filteredCategories = [self.commandCategories filteredArrayUsingPredicate:filter];
    
    if([filteredCategories count] > 0)
    {
        return filteredCategories[0];
    }
    
    return nil;
}

- (int)indexOfCommandCategory:(NSString *)string
{
    NSDictionary *category = [self commandCategoryMatchingSearchString:string];
    
    if(category != nil)
    {
        NSUInteger categoryIndex = [self.commandCategories indexOfObject:category];
        if(categoryIndex != NSNotFound)
        {
            return (int)categoryIndex;
        }
    }
    
    return -1;
}

- (int)commandCategoriesCount
{
    return (int)[[self commandCategories] count];
}

- (NSArray *)commandDictionariesArray
{
    return _commandDictionariesArray;
}

- (int)indexOfCommandWithTitle:(NSString *)title;
{
    NSMutableDictionary *command = [self commandForCommandTitle:title];
    
    if(command != nil)
    {
        NSUInteger commandIndex = [self.commandDictionariesArray indexOfObject:command];
        if(commandIndex != NSNotFound)
        {
            return (int)commandIndex;
        }
    }
    
    return -1;
}

- (NSMutableDictionary *)commandForCommandTitle:(NSString *)title
{
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", title];
    
    NSArray *filteredCommands = [self.commandDictionariesArray filteredArrayUsingPredicate:filter];
    
    if([filteredCommands count] > 0)
    {
        return filteredCommands[0];
    }
    
    return nil;
}

- (NSArray *)commandsForCategory:(NSString *)category
{
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"category CONTAINS[cd] %@", category];
    
    NSArray *filteredCommands = [self.commandDictionariesArray filteredArrayUsingPredicate:filter];
    
    if([filteredCommands count] > 0)
    {
        return filteredCommands;
    }
    
    return nil;
}

- (NSMutableDictionary *)commandForCategory:(NSString *)category atIndex:(int)index
{
    return [[self commandsForCategory:category] objectAtIndex:index];
}

- (int)commandsCountForCategory:(NSString *)category
{
    NSArray *filteredCommands = [self commandsForCategory:category];
    
    return (int)[filteredCommands count];
}

#pragma mark - Public BLE Tx Methods

- (void)writeCommandToArduino:(NSMutableDictionary *)command withState:(int)state andFactoryState:(int)factory
{
    if(command != nil)
    {
        NSString *string;
        if(state != -1 && factory != -1)
        {
            string = [NSString stringWithFormat:@"%@ %@%d %@%d", command[@"baseCommand"], command[@"stateCharacter"], state, command[@"factoryCharacter"], factory];
        }
        else if(state != -1)
        {
            string = [NSString stringWithFormat:@"%@ %@%d", command[@"baseCommand"], command[@"stateCharacter"], state];
        }
        else if(factory != -1)
        {
            string = [NSString stringWithFormat:@"%@ %@%d", command[@"baseCommand"], command[@"factoryCharacter"], factory];
        }
        
        if(string != nil)
        {
            NSLog(@"Writing: %@", string);
            
            // Print the string to the 'console'
            [self writeDebugStringToConsole:[NSString stringWithFormat:@"%@", string] color:[UIColor blueColor]];
            if(state != -1)
            {
                [self writeDebugStringToConsole:[NSString stringWithFormat:@"%@ : %@", command[@"title"], [command[@"stateLabels"] objectAtIndex:state]]];
            }
            if(factory != -1)
            {
                [self writeDebugStringToConsole:[NSString stringWithFormat:@"%@ Factory Status: %@", command[@"title"], (factory ? @"On" : @"Off")]];
            }
            
            // Add the string to our buffer
            [self.bufferToWriteToArduino appendString:string];
            // Append a '\n' to the string so the Arduino knows the command has finished
            [self.bufferToWriteToArduino appendString:@"\n"];
            
            // Handle the connecting to, writing, and disconnecting from the BLE UART device
            [self writeArduinoBuffer:nil];
        }
    }
}

- (void)writeCommandToArduino:(NSMutableDictionary *)command withState:(int)state
{
    [self writeCommandToArduino:command withState:state andFactoryState:-1];
}

- (void)writeCommandToArduino:(NSMutableDictionary *)command withFactoryState:(int)factory
{
    command[@"factoryState"] = @(factory);
    [self writeCommandToArduino:command withState:-1 andFactoryState:factory];
}

- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color
{
    //NSLog(@"%@", string);
    [[self consoleDelegate] writeDebugStringToConsole:string color:color];
}

- (void)writeDebugStringToConsole:(NSString *)string
{
    [self writeDebugStringToConsole:string color:[UIColor blackColor]];
}

- (void)writeStringToArduino:(NSString *)string
{
    if(string != nil)
    {
        NSLog(@"Writing: %@", string);
        
        // Add the string to our buffer
        [self.bufferToWriteToArduino appendString:string];
        // Append a '\n' to the string so the Arduino knows the command has finished
        [self.bufferToWriteToArduino appendString:@"\n"];
        
        // Print the string to the 'console'
        [self writeDebugStringToConsole:[NSString stringWithFormat:@"%@\n", string] color:[UIColor blueColor]];
        
        // Handle the connecting to, writing, and disconnecting from the BLE UART device
        [self writeArduinoBuffer:nil];
    }
}

#pragma mark - BLE TX Methods

- (void)writeArduinoBuffer:(NSTimer *)timer
{
    // If we have data in our buffer, try to write it
    if(self.bufferToWriteToArduino.length > 0)
    {
        // If we are connected, write the data
        if(self.connectionStatus == ConnectionStatusConnected)
        {
            // Break the string up into 20 char lengths if it's too long
            do
            {
                int lastCharIndex = (int)self.bufferToWriteToArduino.length;
                int substringIndex = lastCharIndex;
                if(lastCharIndex > 20)
                {
                    substringIndex = 20;
                }
                
                // Write the string
                NSString *stringToWrite = [self.bufferToWriteToArduino substringToIndex:substringIndex];
                [self writeString:stringToWrite];
                
                // Print the string to the 'console'
                //[self writeDebugStringToConsole:stringToWrite];
                
                // Delete the written data from the buffer
                NSRange writtenStringRange;
                writtenStringRange.location = 0;
                writtenStringRange.length = substringIndex;
                [self.bufferToWriteToArduino deleteCharactersInRange:writtenStringRange];
                
            } while(self.bufferToWriteToArduino.length > 0);
        }
        // We aren't connected yet so try writing the data again in a bit
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(writeArduinoBuffer:) userInfo:nil repeats:NO];
        }
    }
}

- (void)writeString:(NSString*)string
{
    // Send string to peripheral
    NSData *data = [NSData dataWithBytes:string.UTF8String length:string.length];
    
    [self writeRawData:data];
}


- (void)writeRawData:(NSData*)data
{
    // Send data to peripheral
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        
        [self.bluetoothPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.bluetoothPeripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        NSLog(@"No write property on TX characteristic, %d.", (int)self.txCharacteristic.properties);
    }
}

#pragma mark - BLE RX Method

// Data incoming from UART peripheral
- (void)didReceiveData:(NSData*)newData
{
    if (self.connectionStatus == ConnectionStatusConnected || self.connectionStatus == ConnectionStatusScanning)
    {
        // convert data to string & replace characters we can't display
        int dataLength = (int)newData.length;
        uint8_t data[dataLength];
        
        [newData getBytes:&data length:dataLength];
        
        for (int i = 0; i < dataLength; i ++)
        {
            // If it's in the null character range
            if ((data[i] <= 0x1f) || (data[i] >= 0x80))
            {
                // If it's not a 0x9 == TAB, 0xA == \n, 0xD == \r
                if ((data[i] != 0x9) && (data[i] != 0xa) && (data[i] != 0xd))
                {
                    data[i] = 0xA9;
                }
            }
        }
        
        //Debug
        //NSString *hexString = [newData hexRepresentationWithSpaces:YES];
        //NSLog(@"Received: hex:%@", uartString, hexString);
        NSString *uartString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        NSLog(@"Received: %@", uartString);
        //NSLog(@"Received: %@ hex:%@", uartString, hexString);
        // Write the received text to the 'console'
        [self writeDebugStringToConsole:[NSString stringWithFormat:@"Received: %@", uartString] color:[UIColor orangeColor]];
        
        // Only parse valid commands
        if(data[dataLength - 1] == '\n')
        {
            // Find the command for the number that was passed to us
            NSString *baseCommand = [self baseCommandForString:uartString];
            NSMutableDictionary *command = [self commandForBaseCommand:baseCommand];
            if(command != nil)
            {
                // Find the new state
                int commandValue = [self parseString:data whichHasLength:dataLength forCharacter:@"C"];
                int dataValue = [self parseString:data whichHasLength:dataLength forCharacter:command[@"dataCharacter"]];
                NSLog(@"received Command:%d Data:%d", commandValue, dataValue);
                
                if(dataValue >= 0)
                {
                    // Set the new state
                    command[@"currentState"] = @(dataValue);
                    // Tell others about it so things like the buttons can update
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommandStateChanged" object:nil userInfo:@{@"command": command}];
                }
            }
        }
    }
}

- (NSString *)baseCommandForString:(NSString *)string
{
    NSArray *commandPieces = [self commandPiecesForString:string];
    
    if(commandPieces != nil)
    {
        return commandPieces[0];
    }
    
    return nil;
}

- (NSArray *)commandPiecesForString:(NSString *)string
{
    if(string != nil)
    {
        // First get rid of \n
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray *commandPieces = [string componentsSeparatedByString:@" "];
        
        // Build an array of commandPieces that actually have something in them
        NSMutableArray *validCommandPieces = [NSMutableArray new];
        for(int i = 0; i < commandPieces.count; i ++)
        {
            NSString *commandPiece = (NSString *)[commandPieces objectAtIndex:i];
            if(commandPiece.length > 0)
            {
                [validCommandPieces addObject:commandPieces[i]];
            }
        }
        
        // Return the array if we have any commandPices
        if(validCommandPieces.count > 0)
        {
            return (NSArray *)validCommandPieces;
        }
    }
    
    return nil;
}

// function to retrieve command character value
- (int)parseString:(uint8_t *)string whichHasLength:(int)length forCharacter:(NSString *)characterString
{
    char character = [characterString characterAtIndex:0];
    int value = -1;
    uint8_t *ptr = string;
	
	while(ptr && *ptr && ptr < string + length)
    {
        if(*ptr == character)
        {
            return atoi((const char *)ptr + 1);
        }
        
		ptr = (uint8_t *)strchr((const char *)ptr, ' ') + 1;
    }
    
    return value;
}

- (NSMutableDictionary *)commandForBaseCommand:(NSString *)baseCommand
{
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"baseCommand CONTAINS[cd] %@", baseCommand];
    
    NSArray *filteredCommands = [self.commandDictionariesArray filteredArrayUsingPredicate:filter];
    
    if([filteredCommands count] > 0)
    {
        return filteredCommands[0];
    }
    
    return nil;
}

#pragma mark - General BLE Methods

- (void)uartDidEncounterError:(NSString*)error
{
    NSLog(@"uart Error!!!!:%@", error);
    [self writeDebugStringToConsole:[NSString stringWithFormat:@"uart Error!!!!:%@", error]];
    
    // Cancel the connection (disconnect) - we then try to reconnect later
    [self.centralBluetoothManager cancelPeripheralConnection:self.bluetoothPeripheral];
}

- (BOOL)compareID:(CBUUID*)firstID toID:(CBUUID*)secondID
{
    if([[firstID representativeString] compare:[secondID representativeString]] == NSOrderedSame)
    {
        return YES;
    }
    
    return NO;
}

- (void)connectToSerivceIfNotAlreadyConnected:(CBUUID *)serviceID andCharacteristics:(NSArray *)characteristics
{
    // Have we discovered the SERVICE yet?
    NSUInteger serviceUUIDIndex = [self.bluetoothPeripheral.services indexOfObjectPassingTest:^BOOL(CBService *obj, NSUInteger index, BOOL *stop)
                                   {
                                       return [obj.UUID isEqual:serviceID];
                                   }];
    // We haven't discovered the SERVICE yet
    if (serviceUUIDIndex == NSNotFound)
    {
        [self.bluetoothPeripheral discoverServices:@[serviceID]];
    }
    
    // Have we discovered the CHARACTERISTIC_UUID yet?
    CBService *service = self.bluetoothPeripheral.services[serviceUUIDIndex];
    
    for(CBUUID *characteristicID in characteristics)
    {
        NSUInteger characteristicUUIDIndex = [service.characteristics indexOfObjectPassingTest:^BOOL(CBCharacteristic *obj, NSUInteger index, BOOL *stop)
                                              {
                                                  return [obj.UUID isEqual:characteristicID];
                                              }];
        // We haven't discovered the CHARACTERISTIC_UUID yet
        if (characteristicUUIDIndex == NSNotFound)
        {
            [self.bluetoothPeripheral discoverCharacteristics:@[characteristicID] forService:service];
        }
        
        // Subscribe to the rx characteristic if we arent' yet
        CBCharacteristic *characteristic = service.characteristics[characteristicUUIDIndex];
        if(!characteristic.isNotifying && [self compareID:characteristic.UUID toID:RX_CHARACTERISTIC_UUID])
        {
            [self.bluetoothPeripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    NSLog(@"Central Manager Restoring From Background");
    self.isRestoringFromBackground = YES;
    
    // Get a pointer back to a connected UART device
    NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    
    if(peripherals.count > 0)
    {
        self.bluetoothPeripheral = peripherals[0];
        self.bluetoothPeripheral.delegate = self;
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    // respond to bluetooth powered on
    if(central.state == CBCentralManagerStatePoweredOn)
    {
        self.connectionStatus = ConnectionStatusScanning;
        NSLog(@"Bluetooth Powered On");
        [self writeDebugStringToConsole:@"Bluetooth Powered On"];
        
        // Get connected peripherals by other apps
        NSArray *connectedPeripherals = [self.centralBluetoothManager retrieveConnectedPeripheralsWithServices:@[UART_SERVICE_UUID]];
        // Skip scanning if UART is already connected
        if([connectedPeripherals count] > 0)
        {
            NSLog(@"Connecting to BLE from another app");
            [self writeDebugStringToConsole:@"Connecting to BLE from another app"];
            //connect to first peripheral in array
            CBPeripheral *peripheral = [connectedPeripherals objectAtIndex:0];
            
            //Clear off any pending connections
            [self.centralBluetoothManager cancelPeripheralConnection:peripheral];
            
            //Connect
            self.bluetoothPeripheral = peripheral;
            self.bluetoothPeripheral.delegate = self;
            [self.centralBluetoothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES}];
        }
        // Restoring peripheral from background
        else if(self.isRestoringFromBackground)
        {
            NSLog(@"Restoring BLE from background");
            [self writeDebugStringToConsole:@"Restoring BLE from background"];
            // Make sure we have the SERVICES and CHARACTERISTICS (in case we were shut down in the middle of discovery)
            if(self.bluetoothPeripheral.state == CBPeripheralStateConnected)
            {
                [self connectToSerivceIfNotAlreadyConnected:UART_SERVICE_UUID andCharacteristics:@[RX_CHARACTERISTIC_UUID, TX_CHARACTERISTIC_UUID]];
                
                [self connectToSerivceIfNotAlreadyConnected:DEVICE_INFORMATION_SERVICE_UUID andCharacteristics:@[HARDWARE_REVISION_STRING_UUID]];
            }
            
            self.isRestoringFromBackground = NO;
        }
        //Look for available Bluetooth LE devices
        else
        {
            NSLog(@"First time scan");
            [self writeDebugStringToConsole:@"First time scan"];
            [self.centralBluetoothManager scanForPeripheralsWithServices:@[UART_SERVICE_UUID] options:nil];
        }
    }
    // respond to bluetooth powered off
    else if(central.state == CBCentralManagerStatePoweredOff)
    {
        NSString *title = @"Bluetooth Power";
        NSString *message = @"You must turn on Bluetooth in Settings in order to connect to a device";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        self.bluetoothPeripheral = nil;
        self.connectionStatus = ConnectionStatusDisconnected;
        [self writeDebugStringToConsole:@"Bluetooth Powered Off" color:[UIColor redColor]];
    }
    else if(central.state == CBCentralManagerStateUnsupported)
    {
        NSString *title = @"No BLE available";
        NSString *message = @"Your iPhone does not have\nthe necessary hardware to\ncontrol the Mustang.\n\nTime for a new iPhone!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [self writeDebugStringToConsole:@"BLE not available" color:[UIColor redColor]];
    }
    else if(central.state == CBCentralManagerStateUnauthorized)
    {
        NSString *title = @"No BLE authorization";
        NSString *message = @"This app doesn't have permission to access the Bluetooth LE hardware. Please report to James.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [self writeDebugStringToConsole:@"No BLE Authorization" color:[UIColor redColor]];
    }
}

- (void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{
    NSLog(@"Discovered: %@", peripheral.name);
    [self writeDebugStringToConsole:[NSString stringWithFormat:@"Discovered: %@", peripheral.name]];
    
    // Stop scanning for any new devices since we found one
    [self.centralBluetoothManager stopScan];
    
    // Clear off any pending connections
    [self.centralBluetoothManager cancelPeripheralConnection:peripheral];
    
    // Connect
    self.bluetoothPeripheral = peripheral;
    self.bluetoothPeripheral.delegate = self;
    [self.centralBluetoothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES, CBConnectPeripheralOptionNotifyOnConnectionKey: @YES, CBConnectPeripheralOptionNotifyOnNotificationKey: @YES}];
}


- (void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral
{
    if ([self.bluetoothPeripheral isEqual:peripheral])
    {
        // We already discovered the services for the peripheral. Just pass along the peripheral.
        if(self.bluetoothPeripheral.services)
        {
            NSLog(@"Already found services for: %@", peripheral.name);
            [self writeDebugStringToConsole:[NSString stringWithFormat:@"Already found services for: %@", peripheral.name]];
            [self peripheral:peripheral didDiscoverServices:nil]; //already discovered services, DO NOT re-discover. Just pass along the peripheral.
        }
        // We need to discover the services for the peripheral
        else
        {
            NSLog(@"Finding services for: %@", self.bluetoothPeripheral.name);
            [self writeDebugStringToConsole:[NSString stringWithFormat:@"Finding services for: %@", self.bluetoothPeripheral.name]];
            
            self.connectionStatus = ConnectionStatusConnecting;
            // Try to discover the services for the peripheral
            [self.bluetoothPeripheral discoverServices:@[UART_SERVICE_UUID, DEVICE_INFORMATION_SERVICE_UUID]];
        }
    }
}

- (void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    if ([self.bluetoothPeripheral isEqual:peripheral])
    {
        NSLog(@"Disconnected From: %@", self.bluetoothPeripheral.name);
        [self writeDebugStringToConsole:[NSString stringWithFormat:@"Disconnected From: %@", self.bluetoothPeripheral.name] color:[UIColor redColor]];
        
        self.connectionStatus = ConnectionStatusDisconnected;
        
        // We want to be connected, try reconnecting
        [self.centralBluetoothManager connectPeripheral:self.bluetoothPeripheral options:nil];
    }
}

#pragma mark - CBPeripheralDelegate Methods

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverServices:(NSError*)error
{
    // Respond to finding a new service on peripheral
    NSLog(@"Did Discover Services");
    
    if(!error)
    {
        for(CBService *service in [peripheral services])
        {
            // Already discovered characteristic before, DO NOT do it again
            if(service.characteristics != nil)
            {
                [self peripheral:peripheral didDiscoverCharacteristicsForService:service error:nil];
            }
            // Discovered the UART_SERVICE_UUID
            else if([self compareID:service.UUID toID:UART_SERVICE_UUID])
            {
                NSLog(@"Found UART service");
                [self writeDebugStringToConsole:@"Found UART Service"];
                
                NSLog(@"Searching for RX and TX Characteristics");
                [self writeDebugStringToConsole:@"Searching for RX and TX Characteristics"];
                
                // Now try to discover the tx and rx characteristics
                [self.bluetoothPeripheral discoverCharacteristics:@[TX_CHARACTERISTIC_UUID, RX_CHARACTERISTIC_UUID] forService:service];
            }
            // Discovered the DEVICE_INFORMATION_SERVICE_UUID
            else if([self compareID:service.UUID toID:DEVICE_INFORMATION_SERVICE_UUID])
            {
                // Now try to discover the HARDWARE_REVISION_STRING_UUID characteristic
                [self.bluetoothPeripheral discoverCharacteristics:@[HARDWARE_REVISION_STRING_UUID] forService:service];
            }
        }
    }
    else
    {
        NSLog(@"Error discovering services");
        [self uartDidEncounterError:@"Error discovering services"];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error
{
    // Respond to finding a new characteristic on service
    if(!error)
    {
        for(CBCharacteristic *characteristic in [service characteristics])
        {
            if([self compareID:characteristic.UUID toID:RX_CHARACTERISTIC_UUID])
            {
                NSLog(@"Found RX Characteristic");
                [self writeDebugStringToConsole:@"Found RX Characteristic"];
                self.rxCharacteristic = characteristic;
                
                [self.bluetoothPeripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
            }
            else if([self compareID:characteristic.UUID toID:TX_CHARACTERISTIC_UUID])
            {
                NSLog(@"Found TX Characteristic");
                [self writeDebugStringToConsole:@"Found TX Characteristic"];
                self.txCharacteristic = characteristic;
            }
            else if([self compareID:characteristic.UUID toID:HARDWARE_REVISION_STRING_UUID])
            {
                NSLog(@"Found Hardware Revision String Characteristic");
                [self writeDebugStringToConsole:@"Found Hardware Revision String Characteristic"];
                [self.bluetoothPeripheral readValueForCharacteristic:characteristic];
                
                //Once hardware revision string is read connection will be complete …
            }
        }
    }
    else
    {
        NSLog(@"Error discovering characteristics: %@", error.description);
        [self uartDidEncounterError:@"Error discovering characteristics"];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    // Respond to value change on peripheral
    if(!error)
    {
        // Received RX Data
        if(characteristic == self.rxCharacteristic)
        {
            //NSLog(@"Received: %@", [characteristic value]);
            
            [self didReceiveData:[characteristic value]];
        }
        // Received HARDWARE_REVISION_STRING_UUID
        else if([self compareID:characteristic.UUID toID:HARDWARE_REVISION_STRING_UUID])
        {
            NSString *hwRevision = @"";
            const uint8_t *bytes = characteristic.value.bytes;
            for (int i = 0; i < characteristic.value.length; i++)
            {
                hwRevision = [hwRevision stringByAppendingFormat:@"0x%02x, ", bytes[i]];
            }
            
            // Once hardware revision string is read, connection to Bluefruit is complete
            NSString *hwRevisionString = [hwRevision substringToIndex:hwRevision.length - 2];
            NSLog(@"Read HW Revision Value: %@", hwRevisionString);
            [self writeDebugStringToConsole:[NSString stringWithFormat:@"Read HW Revision Value: %@", hwRevisionString]];
            
            self.connectionStatus = ConnectionStatusConnected;
            [self writeDebugStringToConsole:@"Connected!" color:[UIColor greenColor]];
            
            // Send the 'password' to verify
            [self writeStringToArduino:@"P123"];
            
            // Start updating the rssi after a 1 second delay. Update every 0.25 seconds
            double delayInMilliseconds = 1000;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliseconds * NSEC_PER_MSEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               self.rssiTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self.bluetoothPeripheral selector:@selector(readRSSI) userInfo:nil repeats:YES];
                           });
        }
    }
    else
    {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic.description, error.description);
        [self uartDidEncounterError:@"Error receiving notification for characteristic"];
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(error)
    {
        [self writeDebugStringToConsole:[NSString stringWithFormat:@"RSSI Error:%@", error]];
    }
    else
    {
        // Access the RSSI
        self.currentRSSI = self.bluetoothPeripheral.RSSI;
        [self writeDebugStringToConsole:[NSString stringWithFormat:@"RSSI:%@", self.currentRSSI]];
    }
}

#pragma mark - Private Methods

- (void)setConnectionStatus:(ConnectionStatus)connectionStatus
{
    _connectionStatus = connectionStatus;
    
    // Post notification here
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLEConnectionStatusChange" object:[NSNumber numberWithInt:connectionStatus]];
}


@end
