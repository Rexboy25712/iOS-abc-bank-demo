//
//  ABCViewController.m
//  AbcBankDemo
//
//  Created by David Quach on 10/16/14.
//  Copyright (c) 2014 Orasi. All rights reserved.
//

#import "ABCWebViewController.h"
#import "ABCURLData.h"

@interface ABCWebViewController ()

@end

@implementation ABCWebViewController

// Constructs the right bar button on the view
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *navItem = self.navigationItem;
        navItem.hidesBackButton = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped)];
        
        UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonTapped)];
        
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        
        
        navItem.leftBarButtonItems = @[backButton, forwardButton];
        navItem.rightBarButtonItem = logoutButton;
        _URL = [[ABCURLData storedURL] defaultURL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// Sets a webview as the web view controller's view
- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}


// Loads the request whenever the URL property is set on the web view controller
- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

// Function for whenever the logout button is pressed, the web view controller will be
// popped off the navigation controller stack and returned to the login view controller
- (void)logout
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backButtonTapped
{
    [(UIWebView *)self.view goBack];
}

- (void)forwardButtonTapped
{
    [(UIWebView *)self.view goForward];
}

@end
