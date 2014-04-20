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

@end


@implementation MNBluetoothManager

@synthesize consoleDelegate;

#pragma mark - Public Methods

+ (id)sharedBluetoothManager
{
    static MNBluetoothManager *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}

+ (NSArray *)commandSectionNames
{
    static NSArray *commandSectionNames;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commandSectionNames = @[@"Ignition", @"Controls", @"Exterior Lights", @"Interior Lights", @"Miscellaneous"];
    });
    
    return commandSectionNames;
}

+ (NSArray *)commandSectionDictionaryArrays
{
    static NSDictionary *section1Dictionary1;
    static NSArray *section1Dictionaries;
    
    static NSDictionary *section2Dictionary1;
    static NSDictionary *section2Dictionary2;
    static NSDictionary *section2Dictionary3;
    static NSDictionary *section2Dictionary4;
    static NSDictionary *section2Dictionary5;
    static NSDictionary *section2Dictionary6;
    static NSDictionary *section2Dictionary7;
    static NSDictionary *section2Dictionary8;
    static NSDictionary *section2Dictionary9;
    static NSArray *section2Dictionaries;
    
    static NSDictionary *section3Dictionary1;
    static NSDictionary *section3Dictionary2;
    static NSDictionary *section3Dictionary3;
    static NSDictionary *section3Dictionary4;
    static NSDictionary *section3Dictionary5;
    static NSDictionary *section3Dictionary6;
    static NSArray *section3Dictionaries;
    
    static NSDictionary *section4Dictionary1;
    static NSDictionary *section4Dictionary2;
    static NSDictionary *section4Dictionary3;
    static NSDictionary *section4Dictionary4;
    static NSDictionary *section4Dictionary5;
    static NSArray *section4Dictionaries;
    
    static NSDictionary *section5Dictionary1;
    static NSDictionary *section5Dictionary2;
    static NSDictionary *section5Dictionary3;
    static NSDictionary *section5Dictionary4;
    static NSDictionary *section5Dictionary5;
    static NSArray *section5Dictionaries;
    
    static NSArray *commandSectionDictionaryArrays;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Ignition
        section1Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C00", @"baseCommand",
                               @3, @"numberOfStates",
                               @[@"Off", @"Battery", @"Start"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Ignition", @"title",
                               @"Ignition", @"category",
                               nil];
        section1Dictionaries = @[section1Dictionary1];
        
        // Controls
        section2Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C50", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Lock", @"Unlock"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Door Locks", @"title",
                               @"Locks", @"category",
                               nil];
        section2Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C51", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Close", @"Open"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Trunk", @"title",
                               @"Controls", @"category",
                               nil];
        section2Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C52", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Top", @"Bottom"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Left Window", @"title",
                               @"Controls", @"category",
                               nil];
        section2Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C53", @"baseCommand",
                               @3, @"numberOfStates",
                               @[@"Stop", @"Up", @"Down"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Left Window", @"title",
                               @"Controls", @"category",
                               nil];
        section2Dictionary5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C54", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Top", @"Bottom"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Right Window", @"title",
                               @"Controls", @"category",
                               nil];
        
        section2Dictionary6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C55", @"baseCommand",
                               @3, @"numberOfStates",
                               @[@"Stop", @"Up", @"Down"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Right Window", @"title",
                               @"Controls", @"category",
                               nil];
        section2Dictionary7 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C56", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Top", @"Bottom"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Both Windows", @"title",
                               @"Controls", @"category",
                               nil];
        section2Dictionary8 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C57", @"baseCommand",
                               @3, @"numberOfStates",
                               @[@"Stop", @"Up", @"Down"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Both Windows", @"title",
                               @"Controls", @"category",
                               nil];
        section2Dictionary9 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C58", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Close", @"Open",], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Exhause Cutouts", @"title",
                               @"Controls", @"category",
                               nil];
        section2Dictionaries = @[section2Dictionary1, section2Dictionary2, section2Dictionary3, section2Dictionary4, section2Dictionary5, section2Dictionary6, section2Dictionary7, section2Dictionary8, section2Dictionary9];
        
        // Exterior Lights
        section3Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C100", @"baseCommand",
                               @3, @"numberOfStates",
                               @[@"Off", @"Low", @"High"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Headlights", @"title",
                               @"Exterior Lights", @"category",
                               nil];
        section3Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C101", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Fog", @"title",
                               @"Exterior Lights", @"category",
                               nil];
        section3Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C102", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Park", @"title",
                               @"Exterior Lights", @"category",
                               nil];
        section3Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C103", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Backup", @"title",
                               @"Exterior Lights", @"category",
                               nil];
        section3Dictionary5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C104", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Tail Night", @"title",
                               @"Exterior Lights", @"category",
                               nil];
        section3Dictionary6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C105", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"License Plate", @"title",
                               @"Exterior Lights", @"category",
                               nil];
        section3Dictionaries = @[section3Dictionary1, section3Dictionary2, section3Dictionary3, section3Dictionary4, section3Dictionary5, section3Dictionary6];
        
        // Interior Lights
        section4Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C150", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"F", @"factoryCommand",
                               @"Left Pillar", @"title",
                               @"Interior Lights", @"category",
                               nil];
        section4Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C151", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"F", @"factoryCommand",
                               @"Right Pillar", @"title",
                               @"Interior Lights", @"category",
                               nil];
        section4Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C152", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"F", @"factoryCommand",
                               @"Center Console", @"title",
                               @"Interior Lights", @"category",
                               nil];
        section4Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C153", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"F", @"factoryCommand",
                               @"Dome", @"title",
                               @"Interior Lights", @"category",
                               nil];
        section4Dictionary5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C154", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"F", @"factoryCommand",
                               @"Under Dash", @"title",
                               @"Interior Lights", @"category",
                               nil];
        section4Dictionaries = @[section4Dictionary1, section4Dictionary2, section4Dictionary3, section4Dictionary4, section4Dictionary5];
        
        // Miscellaneous
        section5Dictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C200", @"baseCommand",
                               @3, @"numberOfStates",
                               @[@"Slow", @"Medium", @"Fast"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Turn Signal Speed", @"title",
                               @"Miscellaneous", @"category",
                               nil];
        section5Dictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C201", @"baseCommand",
                               @5, @"numberOfStates",
                               @[@"Basic", @"Sequence", @"Chase", @"-Sequence", @"OneByOne"], @"stateLabels",
                               @"S", @"stateCommand",
                               @"Turn Signal Pattern", @"title",
                               @"Miscellaneous", @"category",
                               nil];
        section5Dictionary3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C202", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"L", @"stateCommand",
                               @"Assitive Lighting", @"title",
                               @"Miscellaneous", @"category",
                               nil];
        section5Dictionary4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C203", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"L", @"stateCommand",
                               @"Automatic Lighting", @"title",
                               @"Miscellaneous", @"category",
                               nil];
        section5Dictionary5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"C204", @"baseCommand",
                               @2, @"numberOfStates",
                               @[@"Off", @"On"], @"stateLabels",
                               @"L", @"stateCommand",
                               @"Emergency Flashers", @"title",
                               @"Miscellaneous", @"category",
                               nil];
        section5Dictionaries = @[section5Dictionary1, section5Dictionary2, section5Dictionary3, section5Dictionary4, section5Dictionary5];
        
        commandSectionDictionaryArrays = @[section1Dictionaries, section2Dictionaries, section3Dictionaries, section4Dictionaries, section5Dictionaries];
    });
    
    return commandSectionDictionaryArrays;
}

- (id)init
{
    if(self = [super init])
    {
        bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        connectionStatus = ConnectionStatusDisconnected;
        bufferToWriteToArduino = [[NSMutableString alloc] init];
        
        // Search for and connect to the arduino. Give the BL a second to boot up
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:NO];
    }
    return self;
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
        [self writeDebugStringToConsole:bufferToWriteToArduino color:[UIColor blueColor]];
        
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
