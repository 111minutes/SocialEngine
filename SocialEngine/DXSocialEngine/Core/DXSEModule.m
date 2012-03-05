//
//  DXSEModule.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEModule.h"

@implementation DXSEModule

@synthesize initialConfig;
@synthesize accessToken;

#pragma mark - Init/Dealloc
//==============================================================================
- (id) init
{
    [self release];
    return nil;
}

//==============================================================================
- (id) initWithInitialConfig:(DXSEInitialConfig*) anInitialConfig
{
    if( (self = [super init]) )
    {
        initialConfig = [anInitialConfig retain];
    }
    return self;
}

//==============================================================================
- (void) dealloc
{
    [initialConfig release];
    
    [super dealloc];
}

//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

//==============================================================================
- (void) logout
{
    NSAssert(NO, @"You need override this method");
}

//==============================================================================
- (BOOL) isAuthorized
{
    NSAssert(NO, @"You need override this method");
    return NO;
}

//==============================================================================
- (void) getUserInfoSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

//==============================================================================
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

@end
