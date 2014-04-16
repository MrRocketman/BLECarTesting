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

- (id)init
{
    if(self = [super init])
    {
        bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        connectionStatus = ConnectionStatusDisconnected;
        bufferToWriteToArduino = [[NSMutableString alloc] init];
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
                [self writeDebugStringToConsole:stringToWrite];
                
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
    
    // Disconnect from the BLE once the buffer is empty
    if(bufferToWriteToArduino.length == 0)
    {
        if(connectionStatus != ConnectionStatusDisconnected)
        {
            [self disconnect];
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
