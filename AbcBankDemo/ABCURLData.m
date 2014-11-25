//
//  ABCUrlData.m
//  AbcBankDemo
//
//  Created by David Quach on 11/21/14.
//  Copyright (c) 2014 Orasi. All rights reserved.
//

#import "ABCURLData.h"

@interface ABCURLData ()

@end

@implementation ABCURLData

+ (instancetype)storedURL
{
    static ABCURLData *storedURL = nil;
    
    if (!storedURL) {
        storedURL = [[self alloc] initPrivate];
    }
    
    return storedURL;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ABCURLData storedURL]" userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _URL = [[NSURL alloc] initWithString:@"http://abcbank.orasi.com/"];
    }
    
    return self;
}

- (NSURL *)defaultURL
{
    self.URL = [NSURL URLWithString:@"http://abcbank.orasi.com/"];
    
    return self.URL;
}

@end
