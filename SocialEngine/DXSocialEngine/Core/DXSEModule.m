//
//  DXSEModule.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEModule.h"

@implementation DXSEModule

@synthesize entryConfig;
//@synthesize accessToken;

#pragma mark - Init/Dealloc
//==============================================================================
- (id) init
{
    [self release];
    return nil;
}

//==============================================================================
- (id) initWithEntryConfig:(DXSEntryConfig*) anInitialConfig
{
    if( (self = [super init]) )
    {
        entryConfig = [anInitialConfig retain];
    }
    return self;
}

//==============================================================================
- (void) dealloc
{
    [entryConfig release];
    
    [super dealloc];
}

//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

//==============================================================================
- (void) logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
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
- (NSString*) accessToken
{
    NSAssert(NO, @"You need override this method");
    return nil;
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
