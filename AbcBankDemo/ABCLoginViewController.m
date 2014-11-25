//
//  ABCLoginViewController.m
//  AbcBankDemo
//
//  Created by David Quach on 10/16/14.
//  Copyright (c) 2014 Orasi. All rights reserved.
//

#import "ABCLoginViewController.h"
#import "ABCSettingsTableViewController.h"
#import "ABCWebViewController.h"
#import "ABCURLData.h"

@interface ABCLoginViewController ()

<UITextFieldDelegate, NSURLConnectionDataDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLResponse *response;
@property (nonatomic) ABCSettingsTableViewController *settingsVC;
@property (nonatomic) NSURL *URL;

@end

@implementation ABCLoginViewController

// Initializer for login view controller
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"AbcBankDemo";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
        navItem.rightBarButtonItem = bbi;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        
        _settingsVC = [[ABCSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        _URL = [[ABCURLData storedURL] URL];
    }
    return self;
}

// Allows the view to listen for taps and run the dismissKeyboard function when tapped with one finger
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

// Clears the text field for the username and password
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.usernameField.text = @"";
    self.passwordField.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

// Method to dismiss the keyboard when the view is tapped
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

// Checks if the response is returning the correct URL if not
// then the webview is not pushed onto the navigation controller
// and password field is cleared.
// If url is correct then the web view is pushed on the controller.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSString *url = [[response URL] absoluteString];
    if ([url isEqualToString:[self.URL absoluteString]]) {
        NSLog(@"Login invalid");
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil message:@"Incorrect Password" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [toast show];
        int duration = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        self.passwordField.text = @"";
    } else {
        NSLog(@"Success!!");
        self.webViewController.URL = [[NSURL alloc] initWithString:[url stringByAppendingString:@"/hybrid"]];
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

// Will switch to the next field whenever the next key on the keyboard is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}


// Method to switch to the settings view controller whenever the settings button is pressed
- (void)settings
{
    [self.navigationController pushViewController:self.settingsVC animated:YES];
}

// When the login button is pressed, first checks to make sure the fields are not blank then makes a connection to the server for the user
- (IBAction)login:(id)sender
{
    // Check whether one or both of the text fields are empty, if they are then display an alert and set the appropriate text
    // field as active
    if ([self.usernameField.text isEqualToString:@""] && [self.passwordField.text isEqualToString:@""]) {
        NSLog(@"%@", [[ABCURLData storedURL] URL]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Username and Password cannot be blank."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [self.usernameField becomeFirstResponder];
    } else if ([self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Username cannot be blank."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [self.usernameField becomeFirstResponder];
    } else if ([self.passwordField.text isEqualToString:@""] && ![self.usernameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Password cannot be blank."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [self.passwordField becomeFirstResponder];
    } else {
        NSString *urlSTring = [self.URL absoluteString];
        NSString *requestString = [urlSTring stringByAppendingString:@"login"];
        NSURL *url = [NSURL URLWithString:requestString];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        NSString *params = [NSString stringWithFormat:@"user[username]=%@&user[password]=%@", self.usernameField.text, self.passwordField.text];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[params length]];
        [req setHTTPMethod:@"POST"];
        [req setValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [req setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        [NSURLConnection connectionWithRequest:req delegate:self];
    }
    
}


@end
