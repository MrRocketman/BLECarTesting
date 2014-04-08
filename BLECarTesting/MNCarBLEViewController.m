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

@synthesize connectionStatus, connectDisconnectButton, sendButton, sendTextField, receivedTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    connectionStatus = ConnectionStatusDisconnected;
    
    // Disable the send button if we aren't connected
    [self.sendButton setEnabled:NO];
    [self.sendTextField setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color
{
    // Print the string to the 'console'
    NSString *appendString = @"\n"; //each message appears on new line
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", string, appendString] attributes: @{NSForegroundColorAttributeName : color}];
    NSMutableAttributedString *newASCIIText = [[NSMutableAttributedString alloc] initWithAttributedString:self.receivedTextView.attributedText];
    [newASCIIText appendAttributedString:attrString];
    self.receivedTextView.attributedText = newASCIIText;
    
    // Scroll to the bottom
    CGPoint bottomOffset = CGPointMake(0, self.receivedTextView.contentSize.height - self.receivedTextView.bounds.size.height);
    if (bottomOffset.y > 0)
    {
        [self.receivedTextView setContentOffset:bottomOffset animated:YES];
    }
}

- (void)writeDebugStringToConsole:(NSString *)string
{
    [self writeDebugStringToConsole:string color:[UIColor blackColor]];
}

- (void)writeStringToArduino:(NSString *)string
{
    if(string != nil)
    {
        // Print the string to the 'console'
        [self writeDebugStringToConsole:string color:[UIColor blueColor]];
        
        // Append a '\n' to the string so the Arduino knows the command has finished
        string = [NSString stringWithFormat:@"%@\n", string];
        
        // Break the string up into 20 char lengths if it's too long
        if(string.length > 0)
        {
            do
            {
                int lastCharIndex = (int)string.length;
                int substringIndex = lastCharIndex;
                if(lastCharIndex > 20)
                {
                    substringIndex = 20;
                }
                
                NSString *stringToWrite = [string substringToIndex:substringIndex];
                [currentPeripheral writeString:stringToWrite];
                NSString *newString = [string substringFromIndex:substringIndex];
                string = newString;
                
            } while(string.length > 0);
        }
    }
}

#pragma mark - Button Actions

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

- (IBAction)sendButtonPress:(id)sender
{
    [self writeStringToArduino:self.sendTextField.text];
    self.sendTextField.text = @"";
    [self.sendTextField endEditing:YES];
}

- (IBAction)clearTextViewButtonPress:(id)sender
{
    self.receivedTextView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
}

- (IBAction)doSomethingWithCarButtonPress:(id)sender
{
    [self writeStringToArduino:@"C100 S2"];
}

#pragma mark - UITextFieldDelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.sendTextField)
    {
        // 'Press the send button' when you hit enter
        [self sendButtonPress:self.sendButton];
        
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - My Bluetooth Methods

- (void)scanForPeripherals
{
    //Look for available Bluetooth LE devices
    NSLog(@"Scanning for BLE devices");
    [self writeDebugStringToConsole:@"Scanning for BLE devices"];
    // Change the button text here
    [self.connectDisconnectButton setTitle:@"Scanning For BLE..." forState:UIControlStateNormal];
    
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

#pragma mark - CBCentralManagerDelegate


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
    [self writeDebugStringToConsole:[NSString stringWithFormat:@"Discovered: %@", peripheral.name]];
    
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
            [self writeDebugStringToConsole:[NSString stringWithFormat:@"Connected To: %@", peripheral.name] color:[UIColor greenColor]];
            [currentPeripheral didConnect];
        }
    }
}


- (void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    [self writeDebugStringToConsole:[NSString stringWithFormat:@"Disconnected From: %@", peripheral.name] color:[UIColor redColor]];
    
    //respond to disconnected
    [self peripheralDidDisconnect];
    
    if ([currentPeripheral.peripheral isEqual:peripheral])
    {
        [currentPeripheral didDisconnect];
    }
}

#pragma mark - UARTPeripheralDelegate

//Once hardware revision string is read, connection to Bluefruit is complete
- (void)didReadHardwareRevisionString:(NSString*)string
{
    NSLog(@"HW Revision: %@", string);
    
    // Change the button text here
    [self.connectDisconnectButton setTitle:@"Disconnect From BLE" forState:UIControlStateNormal];
    
    // Enable the send button if we aren't connected
    [self.sendButton setEnabled:YES];
    [self.sendTextField setEnabled:YES];
    
    // Print to the device to confirm operation
    [self sendButtonPress:self.sendButton];
    
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
        //convert data to string & replace characters we can't display
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

//respond to device disconnecting
- (void)peripheralDidDisconnect
{
    /*// If we were in the process of scanning/connecting, dismiss alert
    if (currentAlertView != nil)
    {
        [self uartDidEncounterError:@"Peripheral disconnected"];
    }*/
    
    // Disable the send button if we aren't connected
    [self.sendButton setEnabled:NO];
    [self.sendTextField setEnabled:NO];
    
    // If status was connected, then disconnect was unexpected by the user
    if (connectionStatus == ConnectionStatusConnected)
    {
        NSLog(@"BLE peripheral has disconnected");
        
        // Change the button text here
        [self.connectDisconnectButton setTitle:@"Connect To BLE" forState:UIControlStateNormal];
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
