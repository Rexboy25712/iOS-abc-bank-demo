//
//  ABCUrlData.h
//  AbcBankDemo
//
//  Created by David Quach on 11/21/14.
//  Copyright (c) 2014 Orasi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABCURLData : NSObject

+ (instancetype)storedURL;

- (NSURL *)defaultURL;

@property (nonatomic) NSURL *URL;

@end
