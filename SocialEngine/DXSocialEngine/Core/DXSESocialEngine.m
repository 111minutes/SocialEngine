//
//  DXSocialEngine.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSESocialEngine.h"

@implementation DXSESocialEngine

@synthesize facebook;
@synthesize twitter;
@synthesize fourSquare;

#pragma mark - Init/Dealloc
//==============================================================================
+ (DXSESocialEngine*) sharedInstance
{
    static DXSESocialEngine* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^
                  {
                      sharedInstance = [[DXSESocialEngine alloc] init];
                  });
    
    return sharedInstance;
}

//==============================================================================
- (id) init
{
    if( (self = [super init]) )
    {
        // init with config
        // ...
        // init modules with own config
        // ...
    }
    return self;
}

//==============================================================================
- (void) dealloc
{
    [facebook release];
    [twitter release];
    [fourSquare release];
    
    [super dealloc];
}

//==============================================================================
- (void) configure
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SocialEngine" ofType:@"config"];
    NSDictionary* dicConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"config %@", dicConfig);
//    NSDictionary* [dicConfig objectForKey:@""];
}

@end
