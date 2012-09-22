//
//  RDLinkedInEngineDelegate.h
//  LinkedInClientLibrary
//
//  Created by Sixten Otto on 6/2/11.
//  Copyright 2011 Results Direct. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDLinkedInTypes.h"

@class RDLinkedInEngine;
@class RD_OAToken;

@protocol RDLinkedInEngineDelegate <NSObject>

@optional

- (void)linkedInEngineAccessToken:(RDLinkedInEngine *)engine setAccessToken:(RD_OAToken *)token;
- (RD_OAToken *)linkedInEngineAccessToken:(RDLinkedInEngine *)engine;

- (void)linkedInEngine:(RDLinkedInEngine *)engine requestSucceeded:(RDLinkedInConnectionID *)identifier withResults:(id)results;
- (void)linkedInEngine:(RDLinkedInEngine *)engine requestFailed:(RDLinkedInConnectionID *)identifier withError:(NSError *)error;

@end
