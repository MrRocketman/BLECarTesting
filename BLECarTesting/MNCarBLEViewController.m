//
//  MNFirstViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/1/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNCarBLEViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+hex.h"
#import "NSData+hex.h"

@interface MNCarBLEViewController ()
{
    CBCentralManager *bluetoothManager;
    UARTPeripheral *currentPeripheral;
    UIAlertView *currentAlertView;
}

@end


@implementation MNCarBLEViewController

@synthesize connectionStatus, connectDisconnectButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    connectionStatus = ConnectionStatusDisconnected;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Button Actions

- (IBAction)connectDisconnectButtonPress:(id)sender
{
    if(self.connectionStatus == ConnectionStatusDisconnected)
    {
        // connect to the client here
        connectionStatus = ConnectionStatusScanning;
        [self scanForPeripherals];
    }
    else if(self.connectionStatus == ConnectionStatusScanning)
    {
        // Do nothing
    }
    else if(self.connectionStatus == ConnectionStatusConnected)
    {
        // Disconnect from the client here
        [self disconnect];
    }
}

#pragma mark My Bluetooth Methods

- (void)scanForPeripherals
{
    //Look for available Bluetooth LE devices
    NSLog(@"Scanning for BLE devices");
    // Change the button text here
    [self.connectDisconnectButton setTitle:@"Scanning For BLE" forState:UIControlStateNormal];
    
    //skip scanning if UART is already connected
    NSArray *connectedPeripherals = [bluetoothManager retrieveConnectedPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]];
    if ([connectedPeripherals count] > 0)
    {
        //connect to first peripheral in array
        [self connectPeripheral:[connectedPeripherals objectAtIndex:0]];
    }
    
    else
    {
        [bluetoothManager scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]
                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
    }
}

//Connect Bluetooth LE device
- (void)connectPeripheral:(CBPeripheral*)peripheral
{
    //Clear off any pending connections
    [bluetoothManager cancelPeripheralConnection:peripheral];
    
    //Connect
    currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [bluetoothManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}

- (void)disconnect
{
    //Disconnect Bluetooth LE device
    connectionStatus = ConnectionStatusDisconnected;
    
    [bluetoothManager cancelPeripheralConnection:currentPeripheral.peripheral];
    
    // Change the button text here
    [self.connectDisconnectButton setTitle:@"Connect To BLE" forState:UIControlStateNormal];
}

#pragma mark CBCentralManagerDelegate


- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        
        //respond to powered on
    }
    else if (central.state == CBCentralManagerStatePoweredOff)
    {
        
        //respond to powered off
    }
}

- (void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);
    
    [bluetoothManager stopScan];
    
    [self connectPeripheral:peripheral];
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
            [currentPeripheral didConnect];
        }
    }
}


- (void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    //respond to disconnected
    [self peripheralDidDisconnect];
    
    if ([currentPeripheral.peripheral isEqual:peripheral])
    {
        [currentPeripheral didDisconnect];
    }
}

#pragma mark UARTPeripheralDelegate

//Once hardware revision string is read, connection to Bluefruit is complete
- (void)didReadHardwareRevisionString:(NSString*)string
{
    NSLog(@"HW Revision: %@", string);
    
    // Change the button text here
    [self.connectDisconnectButton setTitle:@"Disconnect From BLE" forState:UIControlStateNormal];
    
    // Print to the device to confirm operation
    [currentPeripheral writeString:@"Test from James"];
    
    connectionStatus = ConnectionStatusConnected;
}

- (void)uartDidEncounterError:(NSString*)error
{
    NSLog(@"uart Error!!!!:%@", error);
}

//Data incoming from UART peripheral
- (void)didReceiveData:(NSData*)newData
{
    //Debug
    NSString *hexString = [newData hexRepresentationWithSpaces:YES];
    NSString *uartString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@ hex:%@", uartString, hexString);
    
    if (connectionStatus == ConnectionStatusConnected || connectionStatus == ConnectionStatusScanning)
    {
        // Do something here
    }
}

//respond to device disconnecting
- (void)peripheralDidDisconnect
{
    /*// If we were in the process of scanning/connecting, dismiss alert
    if (currentAlertView != nil)
    {
        [self uartDidEncounterError:@"Peripheral disconnected"];
    }*/
    
    // If status was connected, then disconnect was unexpected by the user
    if (connectionStatus == ConnectionStatusConnected)
    {
        NSLog(@"BLE peripheral has disconnected");
    }
    
    connectionStatus = ConnectionStatusDisconnected;
}

//Respond to system's bluetooth disabled
- (void)alertBluetoothPowerOff
{
    NSString *title = @"Bluetooth Power";
    NSString *message = @"You must turn on Bluetooth in Settings in order to connect to a device";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

//Respond to unsuccessful connection
- (void)alertFailedConnection
{
    NSString *title     = @"Unable to connect";
    NSString *message   = @"Please check power & wiring,\nthen reset your Arduino";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
