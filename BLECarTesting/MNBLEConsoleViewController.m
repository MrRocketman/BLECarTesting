//
//  MNFirstViewController.m
//  BLECarTesting
//
//  Created by James Adams on 4/1/14.
//  Copyright (c) 2014 JamesAdams. All rights reserved.
//

#import "MNBLEConsoleViewController.h"


@implementation MNBLEConsoleViewController

@synthesize sendButton, sendTextField, consoleTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[MNBluetoothManager sharedBluetoothManager] setConsoleDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)scrollToBottom
{
    // Scroll to the bottom
    CGPoint p = [self.consoleTextView contentOffset];
    [self.consoleTextView setContentOffset:p animated:NO];
    [self.consoleTextView scrollRangeToVisible:NSMakeRange([self.consoleTextView.text length], 0)];
}

#pragma mark - Button Actions

- (IBAction)sendButtonPress:(id)sender
{
    [[MNBluetoothManager sharedBluetoothManager] writeStringToArduino:self.sendTextField.text];
    self.sendTextField.text = @"";
    [self.sendTextField endEditing:YES];
}

- (IBAction)clearTextViewButtonPress:(id)sender
{
    self.consoleTextView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
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

#pragma mark - MNBluetoothManagerDelegate Methods

- (void)writeDebugStringToConsole:(NSString *)string color:(UIColor *)color
{
    // Print the string to the 'console'
    NSString *appendString = @"\n"; //each message appears on new line
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", string, appendString] attributes: @{NSForegroundColorAttributeName : color}];
    NSMutableAttributedString *newASCIIText = [[NSMutableAttributedString alloc] initWithAttributedString:self.consoleTextView.attributedText];
    [newASCIIText appendAttributedString:attrString];
    self.consoleTextView.attributedText = newASCIIText;
    
    // Scroll the textView
    [self scrollToBottom];
}

@end
