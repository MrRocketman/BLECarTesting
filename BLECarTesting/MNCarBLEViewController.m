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
        
        // also change the button text here
    }
    else if(self.connectionStatus == ConnectionStatusScanning)
    {
        // connect to the client here
        
        // also change the button text here
    }
    else if(self.connectionStatus == ConnectionStatusConnected)
    {
        // connect to the client here
        
        // also change the button text here
    }
}

#pragma mark My Bluetooth Methods

- (void)scanForPeripherals
{
    //Look for available Bluetooth LE devices
    
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

- (void)connectPeripheral:(CBPeripheral*)peripheral
{
    //Connect Bluetooth LE device
    
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
}

#pragma mark UIAlertView delegate methods


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // The only button in our alert views is cancel, no need to check button index
    
    if (connectionStatus == ConnectionStatusConnected)
    {
        [self disconnect];
    }
    else if (connectionStatus == ConnectionStatusScanning)
    {
        [bluetoothManager stopScan];
    }
    
    connectionStatus = ConnectionStatusDisconnected;
    
    currentAlertView = nil;
    
    //[self enableConnectionButtons:YES];
    
    //alert dismisses automatically @ return
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
    
    // Print to the device to confirm operation
    [currentPeripheral writeString:@"Test from James's Code"];
    
    //Bail if we aren't in the process of connecting
    if (currentAlertView == nil)
    {
        return;
    }
    
    connectionStatus = ConnectionStatusConnected;
    
    //Load appropriate view controller …
    
    //Pin I/O mode
    /*if (_connectionMode == ConnectionModePinIO) {
        self.pinIoViewController = [[PinIOViewController alloc]initWithDelegate:self];
        _pinIoViewController.navigationItem.rightBarButtonItem = infoBarButton;
        [_pinIoViewController didConnect];
    }
    
    //UART mode
    else if (_connectionMode == ConnectionModeUART){
        self.uartViewController = [[UARTViewController alloc]initWithDelegate:self];
        _uartViewController.navigationItem.rightBarButtonItem = infoBarButton;
        [_uartViewController didConnect];
    }
    
    //Push appropriate viewcontroller onto the navcontroller
    UIViewController *vc = nil;
    
    if (_connectionMode == ConnectionModePinIO)
        vc = _pinIoViewController;
    
    else if (_connectionMode == ConnectionModeUART)
        vc = _uartViewController;
    
    if (vc != nil){
        [_navController pushViewController:vc animated:YES];
    }
    
    else
        NSLog(@"CONNECTED WITH NO CONNECTION MODE SET!");*/
    
    //Dismiss Alert view & update main view
    [currentAlertView dismissWithClickedButtonIndex:-1 animated:NO];
    
    currentAlertView = nil;
}

- (void)uartDidEncounterError:(NSString*)error
{
    //Dismiss "scanning …" alert view if shown
    if (currentAlertView != nil)
    {
        [currentAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    
    //Display error alert
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                   message:error
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
}

//Data incoming from UART peripheral
- (void)didReceiveData:(NSData*)newData
{
    //Debug
    NSString *hexString = [newData hexRepresentationWithSpaces:YES];
    NSLog(@"Received: %@", hexString);
    
    if (connectionStatus == ConnectionStatusConnected || connectionStatus == ConnectionStatusScanning)
    {
        //UART
        /*if (_connectionMode == ConnectionModeUART) {
            //send data to UART Controller
            [_uartViewController receiveData:newData];
        }
        
        //Pin I/O
        else if (_connectionMode == ConnectionModePinIO){
            //send data to PIN IO Controller
            [_pinIoViewController receiveData:newData];
        }*/
    }
}

//respond to device disconnecting
- (void)peripheralDidDisconnect
{
    // If we were in the process of scanning/connecting, dismiss alert
    if (currentAlertView != nil)
    {
        [self uartDidEncounterError:@"Peripheral disconnected"];
    }
    
    // If status was connected, then disconnect was unexpected by the user, show alert
    //UIViewController *topVC = [_navController topViewController];
    if (connectionStatus == ConnectionStatusConnected) //&& ([topVC isMemberOfClass:[PinIOViewController class]] || [topVC isMemberOfClass:[UARTViewController class]]))
    {
        //return to main view
        //[_navController popToRootViewControllerAnimated:YES];
        
        //display disconnect alert
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Disconnected"
                                                       message:@"BLE peripheral has disconnected"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
        
        [alert show];
    }
    
    connectionStatus = ConnectionStatusDisconnected;
    
    //make reconnection available after short delay
    //[self performSelector:@selector(enableConnectionButtons) withObject:nil afterDelay:1.0f];
}

//Respond to system's bluetooth disabled
- (void)alertBluetoothPowerOff
{
    NSString *title     = @"Bluetooth Power";
    NSString *message   = @"You must turn on Bluetooth in Settings in order to connect to a device";
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
