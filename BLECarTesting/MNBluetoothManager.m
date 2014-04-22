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
@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;

@property NSMutableString *bufferToWriteToArduino;

@property(strong, nonatomic) NSArray *commandDictionariesArray;
@property(strong, nonatomic) NSArray *commandCategories;

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
                                      @"title" : @"Left Window Move",
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
                                      @"title" : @"Right Window Move",
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
                                      @"title" : @"Both Windows Move",
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

#pragma mark - Public BLE Tx Methods

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
    //Debug
    //NSString *hexString = [newData hexRepresentationWithSpaces:YES];
    //NSLog(@"Received: hex:%@", uartString, hexString);
    NSString *uartString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@", uartString);
    //NSLog(@"Received: %@ hex:%@", uartString, hexString);
    
    if (self.connectionStatus == ConnectionStatusConnected || self.connectionStatus == ConnectionStatusScanning)
    {
        // convert data to string & replace characters we can't display
        int dataLength = (int)newData.length;
        uint8_t data[dataLength];
        
        [newData getBytes:&data length:dataLength];
        
        for (int i = 0; i<dataLength; i++)
        {
            if ((data[i] <= 0x1f) || (data[i] >= 0x80)) //null characters
            {
                if ((data[i] != 0x9) && //0x9 == TAB
                    (data[i] != 0xa) && //0xA == NL
                    (data[i] != 0xd)) //0xD == CR
                {
                    data[i] = 0xA9;
                }
            }
        }
        
        // Write the received text to the 'console'
        [self writeDebugStringToConsole:uartString color:[UIColor orangeColor]];
    }
}

#pragma mark - General BLE Methods

- (void)uartDidEncounterError:(NSString*)error
{
    NSLog(@"uart Error!!!!:%@", error);
    
    NSString *title = @"UART Error";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)compareID:(CBUUID*)firstID toID:(CBUUID*)secondID
{
    if([[firstID representativeString] compare:[secondID representativeString]] == NSOrderedSame)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
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
        NSLog(@"Scanning for BLE devices");
        [self writeDebugStringToConsole:@"Scanning for BLE devices"];
        
        // Get connected peripherals by other apps
        NSArray *connectedPeripherals = [self.centralBluetoothManager retrieveConnectedPeripheralsWithServices:@[UART_SERVICE_UUID]];
        // Skip scanning if UART is already connected
        if([connectedPeripherals count] > 0)
        {
            //connect to first peripheral in array
            CBPeripheral *peripheral = [connectedPeripherals objectAtIndex:0];
            
            //Clear off any pending connections
            [self.centralBluetoothManager cancelPeripheralConnection:peripheral];
            
            //Connect
            self.bluetoothPeripheral = peripheral;
            self.bluetoothPeripheral.delegate = self;
            [self.centralBluetoothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES}];
        }
        else if(self.bluetoothPeripheral != nil)
        {
            
        }
        //Look for available Bluetooth LE devices
        else
        {
            [self.centralBluetoothManager scanForPeripheralsWithServices:@[UART_SERVICE_UUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
        }
    }
    // respond to bluetooth powered off
    else if(central.state == CBCentralManagerStatePoweredOff)
    {
        NSString *title = @"Bluetooth Power";
        NSString *message = @"You must turn on Bluetooth in Settings in order to connect to a device";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if(central.state == CBCentralManagerStateUnsupported)
    {
        NSString *title = @"No BLE available";
        NSString *message = @"Your iPhone does not have\nthe necessary hardware to\ncontrol the Mustang.\n\nTime for a new iPhone!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if(central.state == CBCentralManagerStateUnauthorized)
    {
        NSString *title = @"No BLE authorization";
        NSString *message = @"This app doesn't have permission to access the Bluetooth LE hardware. Please report to James.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);
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
            NSLog(@"Did connect to existing peripheral %@", peripheral.name);
            [self peripheral:peripheral didDiscoverServices:nil]; //already discovered services, DO NOT re-discover. Just pass along the peripheral.
        }
        // We need to discover the services for the peripheral
        else
        {
            NSLog(@"Did connect peripheral %@", peripheral.name);
            NSLog(@"Starting service discovery for %@", self.bluetoothPeripheral.name);
            [self writeDebugStringToConsole:[NSString stringWithFormat:@"Connecting To: %@", peripheral.name]];
            
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
        NSLog(@"Did disconnect peripheral %@", peripheral.name);
        [self writeDebugStringToConsole:[NSString stringWithFormat:@"Disconnected From: %@", peripheral.name] color:[UIColor redColor]];
        
        // If status was connected, then disconnect was unexpected by the user
        if(self.connectionStatus == ConnectionStatusConnected)
        {
            NSLog(@"BLE peripheral has disconnected");
        }
        self.connectionStatus = ConnectionStatusDisconnected;
        self.bluetoothPeripheral = nil;
        
        // We want to be connected, try reconnecting
        [self.centralBluetoothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES}];
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
                NSLog(@"Found correct service");
                self.uartService = service;
                
                // Now try to discover the tx and rx characteristics
                [self.bluetoothPeripheral discoverCharacteristics:@[TX_CHARACTERISTIC_UUID, RX_CHARACTERISTIC_UUID] forService:self.uartService];
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
        
        return;
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
                self.rxCharacteristic = characteristic;
                
                [self.bluetoothPeripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
            }
            else if([self compareID:characteristic.UUID toID:TX_CHARACTERISTIC_UUID])
            {
                NSLog(@"Found TX Characteristic");
                self.txCharacteristic = characteristic;
            }
            else if([self compareID:characteristic.UUID toID:HARDWARE_REVISION_STRING_UUID])
            {
                NSLog(@"Found Hardware Revision String Characteristic");
                [self.bluetoothPeripheral readValueForCharacteristic:characteristic];
                
                //Once hardware revision string is read connection will be complete …
            }
        }
    }
    else
    {
        NSLog(@"Error discovering characteristics: %@", error.description);
        [self uartDidEncounterError:@"Error discovering characteristics"];
        
        return;
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
                hwRevision = [hwRevision stringByAppendingFormat:@"0x%x, ", bytes[i]];
            }
            
            // Once hardware revision string is read, connection to Bluefruit is complete
            NSString *hwRevisionString = [hwRevision substringToIndex:hwRevision.length - 2];
            NSLog(@"HW Revision: %@", hwRevisionString);
            
            self.connectionStatus = ConnectionStatusConnected;
            [self writeDebugStringToConsole:@"Connected!" color:[UIColor greenColor]];
            
            // Send the 'password' to verify
            [self writeStringToArduino:@"P123"];
        }
    }
    else
    {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic.description, error.description);
        [self uartDidEncounterError:@"Error receiving notification for characteristic"];
        
        return;
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    // Call this method to update RSSI and to get into peripheralDidUpdateRSSI: error:
    //[self.bluetoothPeripheral readRSSI];
    
    // Access the RSSI
    //self.bluetoothPeripheral.RSSI
}

#pragma mark - Private Methods

- (void)setConnectionStatus:(ConnectionStatus)connectionStatus
{
    _connectionStatus = connectionStatus;
    
    // Post notification here
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLEConnectionStatusChange" object:[NSNumber numberWithInt:connectionStatus]];
}


@end
