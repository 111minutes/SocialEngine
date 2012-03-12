//
//  DXSocialEngine.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSESocialEngine.h"


//==============================================================================
//==============================================================================
//==============================================================================
@interface DXSESocialEngine (Private)

- (void) configure;
- (DXSEModule*) initializeModuleWithKey:(NSString*)aModuleKey fromDictionary:(NSDictionary*)aDictionary;

@end


//==============================================================================
//==============================================================================
//==============================================================================
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
        [self configure];
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
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SocialEngine" ofType:@"plist"];
    NSDictionary* dictConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSAssert(dictConfig, @"Need config file!");
    NSLog(@"config %@", dictConfig);

    facebook = [(DXSEFacebook*)[self initializeModuleWithKey:@"DXSEFacebook" fromDictionary:dictConfig] retain];
    twitter = [(DXSETwitter*)[self initializeModuleWithKey:@"DXSETwitter" fromDictionary:dictConfig] retain];
    fourSquare = [(DXSE4Square*)[self initializeModuleWithKey:@"DXSE4Square" fromDictionary:dictConfig] retain];
}

//==============================================================================
- (DXSEModule*) initializeModuleWithKey:(NSString*)aModuleKey fromDictionary:(NSDictionary*)aDictionary
{
    DXSEModule* result = nil;
    NSDictionary* moduleDict = [aDictionary objectForKey:aModuleKey];
    if(moduleDict)
    {
        DXSEntryConfig* initialConfig = [[DXSEntryConfig alloc] initWithDictionary:moduleDict];
        if(initialConfig)
            result = [[[NSClassFromString(aModuleKey) alloc] initWithEntryConfig:initialConfig] autorelease];
        [initialConfig release];
    }
    
    return result;
}

//==============================================================================
- (DXSEModule *) firstAuthorizedModule
{
    return [facebook isAuthorized] ? facebook : [twitter isAuthorized] ? twitter : [fourSquare isAuthorized] ? fourSquare : nil; 
}

@end
