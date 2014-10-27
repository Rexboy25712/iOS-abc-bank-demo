//
//  ABCLoginViewController.h
//  AbcBankDemo
//
//  Created by David Quach on 10/16/14.
//  Copyright (c) 2014 Orasi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABCWebViewController;

@interface ABCLoginViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)login:(id)sender;

@property (nonatomic) ABCWebViewController *webViewController;
@end
