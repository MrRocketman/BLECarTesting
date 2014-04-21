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

@interface MNBluetoothManager()
{
    CBCentralManager *bluetoothManager;
    UARTPeripheral *currentPeripheral;
    ConnectionStatus connectionStatus;
    UIAlertView *currentAlertView;
    
    NSMutableString *bufferToWriteToArduino;
}

@property(readwrite, nonatomic) NSArray *commandDictionariesArray;
@property(readwrite, nonatomic) NSArray *commandCategories;

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
        bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        connectionStatus = ConnectionStatusDisconnected;
        bufferToWriteToArduino = [[NSMutableString alloc] init];
        
        // Ignition
        NSDictionary *dictionary1 = @{@"baseCommand" : @"C00",
                                     @"numberOfStates" : @3,
                                     @"stateLabels" : @[@"Off", @"Battery", @"Start"],
                                     @"stateCommand" : @"S",
                                     @"title" : @"Ignition",
                                     @"category" : @"Ignition"};
        
        // Controls
        NSDictionary *dictionary2 = @{@"baseCommand" : @"C50",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Lock", @"Unlock"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Door Locks",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary3 = @{@"baseCommand" : @"C51",
                                      @"numberOfStates" : @3,
                                      @"stateLabels" : @[@"Close", @"Open", @"Stop"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Trunk",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary4 = @{@"baseCommand" : @"C52",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Top", @"Bottom"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Left Window",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary5 = @{@"baseCommand" : @"C53",
                                      @"numberOfStates" : @3,
                                      @"stateLabels" : @[@"Stop", @"Up", @"Down"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Left Window",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary6 = @{@"baseCommand" : @"C54",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Top", @"Bottom"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Right Window",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary7 = @{@"baseCommand" : @"C55",
                                      @"numberOfStates" : @3,
                                      @"stateLabels" : @[@"Stop", @"Up", @"Down"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Right Window",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary8 = @{@"baseCommand" : @"C56",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Top", @"Bottom"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Both Windows",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary9 = @{@"baseCommand" : @"C57",
                                      @"numberOfStates" : @3,
                                      @"stateLabels" : @[@"Stop", @"Up", @"Down"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Both Windows",
                                      @"category" : @"Controls"};
        NSDictionary *dictionary10 = @{@"baseCommand" : @"C58",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Close", @"Open"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Exhaust Cutouts",
                                      @"category" : @"Controls"};
        
        // Exterior Lights
        NSDictionary *dictionary11 = @{@"baseCommand" : @"C100",
                                      @"numberOfStates" : @3,
                                      @"stateLabels" : @[@"Off", @"Low", @"High"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Headlights",
                                      @"category" : @"Exterior Lights"};
        NSDictionary *dictionary12 = @{@"baseCommand" : @"C101",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Fog",
                                      @"category" : @"Exterior Lights"};
        NSDictionary *dictionary13 = @{@"baseCommand" : @"C106",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Emergency Flahsers",
                                      @"category" : @"Exterior Lights"};
        NSDictionary *dictionary14 = @{@"baseCommand" : @"C102",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Parking",
                                      @"category" : @"Exterior Lights"};
        NSDictionary *dictionary15 = @{@"baseCommand" : @"C103",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Backup",
                                      @"category" : @"Exterior Lights"};
        NSDictionary *dictionary16 = @{@"baseCommand" : @"C104",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Tail Dims",
                                      @"category" : @"Exterior Lights"};
        NSDictionary *dictionary17 = @{@"baseCommand" : @"C105",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"License Plate",
                                      @"category" : @"Exterior Lights"};
        
        // Interior Lights
        NSDictionary *dictionary18 = @{@"baseCommand" : @"C150",
                                       @"numberOfStates" : @2,
                                       @"stateLabels" : @[@"Close", @"Open"],
                                       @"stateCommand" : @"S",
                                       @"factoryCommand" : @"F",
                                       @"title" : @"Left Pillar",
                                       @"category" : @"Interior Lights"};
        NSDictionary *dictionary19 = @{@"baseCommand" : @"C151",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Close", @"Open"],
                                      @"stateCommand" : @"S",
                                       @"factoryCommand" : @"F",
                                      @"title" : @"Right Pillar",
                                      @"category" : @"Interior Lights"};
        NSDictionary *dictionary20 = @{@"baseCommand" : @"C152",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Close", @"Open"],
                                      @"stateCommand" : @"S",
                                       @"factoryCommand" : @"F",
                                      @"title" : @"Center Console",
                                      @"category" : @"Interior Lights"};
        NSDictionary *dictionary21 = @{@"baseCommand" : @"C153",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Close", @"Open"],
                                      @"stateCommand" : @"S",
                                       @"factoryCommand" : @"F",
                                      @"title" : @"Dome",
                                      @"category" : @"Interior Lights"};
        NSDictionary *dictionary22 = @{@"baseCommand" : @"C154",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Close", @"Open"],
                                      @"stateCommand" : @"S",
                                       @"factoryCommand" : @"F",
                                      @"title" : @"Under Dash",
                                      @"category" : @"Interior Lights"};
        
        // Miscellaneous
        NSDictionary *dictionary23 = @{@"baseCommand" : @"C200",
                                      @"numberOfStates" : @3,
                                      @"stateLabels" : @[@"Slow", @"Medium", @"Fast"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Turn Signal Speed",
                                      @"category" : @"Miscellaneous"};
        NSDictionary *dictionary24 = @{@"baseCommand" : @"C201",
                                      @"numberOfStates" : @5,
                                      @"stateLabels" : @[@"Basic", @"Sequence", @"Chase", @"-Sequence", @"OneByOne"],
                                      @"stateCommand" : @"S",
                                      @"title" : @"Turn Signal Patterns",
                                      @"category" : @"Miscellaneous"};
        NSDictionary *dictionary25 = @{@"baseCommand" : @"C202",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"L",
                                      @"title" : @"Assistive Lighting",
                                      @"category" : @"Miscellaneous"};
        NSDictionary *dictionary26 = @{@"baseCommand" : @"C203",
                                      @"numberOfStates" : @2,
                                      @"stateLabels" : @[@"Off", @"On"],
                                      @"stateCommand" : @"A",
                                      @"title" : @"Automatic Lighting",
                                      @"category" : @"Miscellaneous"};
        
        self.commandDictionariesArray = @[dictionary1, dictionary2, dictionary3, dictionary4, dictionary5, dictionary6, dictionary7, dictionary8, dictionary9, dictionary10, dictionary11, dictionary12, dictionary13, dictionary14, dictionary15, dictionary16, dictionary17, dictionary18, dictionary19, dictionary20, dictionary21, dictionary22, dictionary23, dictionary24, dictionary25, dictionary26];
        
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
        
        // Search for and connect to the arduino. Give the BL a second to boot up
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:NO];
    }
    return self;
}

#pragma mark - Command Methods

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
    NSDictionary *command = [self commandForCommandTitle:title];
    
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

- (NSDictionary *)commandForCommandTitle:(NSString *)title
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

- (NSDictionary *)commandForCategory:(NSString *)category atIndex:(int)index
{
    return [[self commandsForCategory:category] objectAtIndex:index];
}

- (int)commandsCountForCategory:(NSString *)category
{
    NSArray *filteredCommands = [self commandsForCategory:category];
    
    return (int)[filteredCommands count];
}

#pragma mark - BLE Methods

- (void)writeCommandToArduino:(NSDictionary *)command withState:(int)state andFactoryState:(int)factory
{
    // Command example
    /*NSDictionary *dictionary22 = @{@"baseCommand" : @"C154",
     @"numberOfStates" : @2,
     @"stateLabels" : @[@"Close", @"Open"],
     @"stateCommand" : @"S",
     @"factoryCommand" : @"F",
     @"title" : @"Under Dash",
     @"category" : @"Interior Lights"};*/
    
    
    if(command != nil)
    {
        NSString *string = [NSString stringWithFormat:@"%@ %@%d %@%d", command[@"baseCommand"], command[@"stateCommand"], state, command[@"factoryCommand"], factory];
        
        [self writeStringToArduino:string];
    }
}

- (void)writeCommandToArduino:(NSDictionary *)command withState:(int)state
{
    // Command example
    /*NSDictionary *dictionary22 = @{@"baseCommand" : @"C154",
     @"numberOfStates" : @2,
     @"stateLabels" : @[@"Close", @"Open"],
     @"stateCommand" : @"S",
     @"factoryCommand" : @"F",
     @"title" : @"Under Dash",
     @"category" : @"Interior Lights"};*/
    
    
    if(command != nil)
    {
        NSString *string = [NSString stringWithFormat:@"%@ %@%d", command[@"baseCommand"], command[@"stateCommand"], state];
        
        [self writeStringToArduino:string];
    }
}

- (void)writeCommandToArduino:(NSDictionary *)command withFactoryState:(int)factory
{
    // Command example
    /*NSDictionary *dictionary22 = @{@"baseCommand" : @"C154",
                                   @"numberOfStates" : @2,
                                   @"stateLabels" : @[@"Close", @"Open"],
                                   @"stateCommand" : @"S",
                                   @"factoryCommand" : @"F",
                                   @"title" : @"Under Dash",
                                   @"category" : @"Interior Lights"};*/
    
    
    if(command != nil)
    {
        NSString *string = [NSString stringWithFormat:@"%@ %@%d", command[@"baseCommand"], command[@"factoryCommand"], factory];
        
        [self writeStringToArduino:string];
    }
}

- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color
{
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
        // Add the string to our buffer
        [bufferToWriteToArduino appendString:string];
        // Append a '\n' to the string so the Arduino knows the command has finished
        [bufferToWriteToArduino appendString:@"\n"];
        
        // Print the string to the 'console'
        [self writeDebugStringToConsole:[NSString stringWithFormat:@"%@\n", string] color:[UIColor blueColor]];
        
        // Handle the connecting to, writing, and disconnecting from the BLE UART device
        [self writeArduinoBuffer:nil];
    }
}

#pragma mark - Private Methods

- (void)writeArduinoBuffer:(NSTimer *)timer
{
    // If we have data in our buffer, try to write it
    if(bufferToWriteToArduino.length > 0)
    {
        // Connect to the BLE device if we aren't already
        if(connectionStatus == ConnectionStatusDisconnected)
        {
            // Connect to the BLE
            [self scanForPeripherals];
        }
        
        // If we are connected, write the data
        if(connectionStatus == ConnectionStatusConnected)
        {
            // Break the string up into 20 char lengths if it's too long
            do
            {
                int lastCharIndex = (int)bufferToWriteToArduino.length;
                int substringIndex = lastCharIndex;
                if(lastCharIndex > 20)
                {
                    substringIndex = 20;
                }
                
                // Write the string
                NSString *stringToWrite = [bufferToWriteToArduino substringToIndex:substringIndex];
                [currentPeripheral writeString:stringToWrite];
                
                // Print the string to the 'console'
                //[self writeDebugStringToConsole:stringToWrite];
                
                // Delete the written data from the buffer
                NSRange writtenStringRange;
                writtenStringRange.location = 0;
                writtenStringRange.length = substringIndex;
                [bufferToWriteToArduino deleteCharactersInRange:writtenStringRange];
                
            } while(bufferToWriteToArduino.length > 0);
        }
        // We aren't connected yet so try writing the data again in a bit
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(writeArduinoBuffer:) userInfo:nil repeats:NO];
        }
    }
}

#pragma mark - My Bluetooth Methods

- (void)scanForPeripherals
{
    //Look for available Bluetooth LE devices
    connectionStatus = ConnectionStatusScanning;
    NSLog(@"Scanning for BLE devices");
    [self writeDebugStringToConsole:@"Scanning for BLE devices"];
    
    // skip scanning if UART is already connected
    NSArray *connectedPeripherals = [bluetoothManager retrieveConnectedPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]];
    if ([connectedPeripherals count] > 0)
    {
#pragma mark !!! Maybe delete this code
        //connect to first peripheral in array
        CBPeripheral *peripheral = [connectedPeripherals objectAtIndex:0];
        
        //Clear off any pending connections
        [bluetoothManager cancelPeripheralConnection:peripheral];
        
        //Connect
        currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
        [bluetoothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    }
    else
    {
        [bluetoothManager scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]
                                                 options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
    }
}

- (void)disconnect
{
    // Disconnect Bluetooth LE device
    connectionStatus = ConnectionStatusDisconnected;
    
    [bluetoothManager cancelPeripheralConnection:currentPeripheral.peripheral];
}

#pragma mark - CBCentralManagerDelegate


- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        // respond to bluetooth powered on
    }
    else if (central.state == CBCentralManagerStatePoweredOff)
    {
        // respond to bluetooth powered off
    }
}

- (void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);
    [self writeDebugStringToConsole:[NSString stringWithFormat:@"Discovered: %@", peripheral.name]];
    
    [bluetoothManager stopScan];
    
    //Clear off any pending connections
    [bluetoothManager cancelPeripheralConnection:peripheral];
    
    //Connect
    currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [bluetoothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}


- (void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral
{
    if ([currentPeripheral.peripheral isEqual:peripheral])
    {
        if(peripheral.services)
        {
            NSLog(@"Did connect to existing peripheral %@", peripheral.name);
            [currentPeripheral peripheral:peripheral didDiscoverServices:nil]; //already discovered services, DO NOT re-discover. Just pass along the peripheral.
        }
        else
        {
            NSLog(@"Did connect peripheral %@", peripheral.name);
            [self writeDebugStringToConsole:[NSString stringWithFormat:@"Connecting To: %@", peripheral.name]];
            [currentPeripheral didConnect];
        }
    }
}


- (void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    [self writeDebugStringToConsole:[NSString stringWithFormat:@"Disconnected From: %@", peripheral.name] color:[UIColor redColor]];
    
    // If status was connected, then disconnect was unexpected by the user
    if (connectionStatus == ConnectionStatusConnected)
    {
        NSLog(@"BLE peripheral has disconnected");
    }
    connectionStatus = ConnectionStatusDisconnected;
    
    if ([currentPeripheral.peripheral isEqual:peripheral])
    {
        [currentPeripheral didDisconnect];
    }
    
    // We want to be connected, try reconnecting
    [self scanForPeripherals];
}

#pragma mark - UARTPeripheralDelegate

// Once hardware revision string is read, connection to Bluefruit is complete
- (void)didReadHardwareRevisionString:(NSString*)string
{
    NSLog(@"HW Revision: %@", string);
    
    connectionStatus = ConnectionStatusConnected;
    [self writeDebugStringToConsole:@"Connected!" color:[UIColor greenColor]];
}

- (void)uartDidEncounterError:(NSString*)error
{
    NSLog(@"uart Error!!!!:%@", error);
}

// Data incoming from UART peripheral
- (void)didReceiveData:(NSData*)newData
{
    //Debug
    NSString *hexString = [newData hexRepresentationWithSpaces:YES];
    NSString *uartString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@ hex:%@", uartString, hexString);
    
    if (connectionStatus == ConnectionStatusConnected || connectionStatus == ConnectionStatusScanning)
    {
        // convert data to string & replace characters we can't display
        int dataLength = (int)newData.length;
        uint8_t data[dataLength];
        
        [newData getBytes:&data length:dataLength];
        
        for (int i = 0; i<dataLength; i++) {
            
            if ((data[i] <= 0x1f) || (data[i] >= 0x80)) {    //null characters
                if ((data[i] != 0x9) && //0x9 == TAB
                    (data[i] != 0xa) && //0xA == NL
                    (data[i] != 0xd)) { //0xD == CR
                    data[i] = 0xA9;
                }
            }
        }
        
        // Write the received text to the 'console'
        [self writeDebugStringToConsole:uartString color:[UIColor orangeColor]];
    }
}

// Respond to system's bluetooth disabled
- (void)alertBluetoothPowerOff
{
    NSString *title = @"Bluetooth Power";
    NSString *message = @"You must turn on Bluetooth in Settings in order to connect to a device";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

// Respond to unsuccessful connection
- (void)alertFailedConnection
{
    NSString *title = @"Unable to connect";
    NSString *message = @"Please check power & wiring,\nthen reset your Arduino";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


@end
