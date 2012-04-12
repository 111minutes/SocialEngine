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

@interface DXSESocialEngine ()

@property (nonatomic, readwrite, strong) DXSEFacebook* facebook;
@property (nonatomic, readwrite, strong) DXSETwitter* twitter;
@property (nonatomic, readwrite, strong) DXSE4Square* fourSquare;
@property (nonatomic, readwrite, strong) DXSEInstagram* instagram;

@end

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
@synthesize instagram;

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

}

//==============================================================================
- (void) configure
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SocialEngine" ofType:@"plist"];
    NSDictionary* dictConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSAssert(dictConfig, @"Need config file!");
    NSLog(@"config %@", dictConfig);

    self.facebook = (DXSEFacebook*)[self initializeModuleWithKey:@"DXSEFacebook" fromDictionary:dictConfig];
    self.twitter = (DXSETwitter*)[self initializeModuleWithKey:@"DXSETwitter" fromDictionary:dictConfig];
    self.fourSquare = (DXSE4Square*)[self initializeModuleWithKey:@"DXSE4Square" fromDictionary:dictConfig];
    self.instagram = (DXSEInstagram*)[self initializeModuleWithKey:@"DXSEInstagram" fromDictionary:dictConfig];
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
            result = [[NSClassFromString(aModuleKey) alloc] initWithEntryConfig:initialConfig];
        initialConfig = nil;
    }
    
    return result;
}

//==============================================================================
- (DXSEModule *) firstAuthorizedModule
{
    return [facebook isAuthorized] ? facebook : [twitter isAuthorized] ? twitter : [fourSquare isAuthorized] ? fourSquare : [instagram isAuthorized] ? instagram : nil; 
}

@end
