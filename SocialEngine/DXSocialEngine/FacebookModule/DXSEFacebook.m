//
//  DXSEFacebook.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEFacebook.h"
#import "SCFacebook.h"


@implementation DXSEFacebook

#pragma mark - Init/Dealloc
//==============================================================================
- (id) init
{
    [self release];
    return nil;
}

//==============================================================================
- (id) initWithEntryConfig:(DXSEntryConfig *)anInitialConfig
{
    if( (self = [super initWithEntryConfig:anInitialConfig]) )
    {
        [SCFacebook shared].oauthKey = entryConfig.oauthKey;
        [[SCFacebook shared] configure];
    }
    return self;
}

//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [SCFacebook loginCallBack:^(BOOL success, id result)
    {
        if (success)
        {
            aSuccess(self, nil);
            accessToken = [[SCFacebook shared].facebook.accessToken retain];
        }
        else
        {
            if(result)
            {
//                NSError* error = [[NSError alloc] initWithDomain:<#(NSString *)#> code:<#(NSInteger)#> userInfo:<#(NSDictionary *)#>]
                aFailure(nil);
            }
        }
    }];
}

//==============================================================================
- (void) logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [SCFacebook logoutCallBack:^(BOOL success, id result)
    {
        if (success)
        {
            aSuccess(self, nil);
            [accessToken release];
            accessToken = nil;
        }
        else
        {
            if(result)
            {
//                NSError* error = [[NSError alloc] initWithDomain:<#(NSString *)#> code:<#(NSInteger)#> userInfo:<#(NSDictionary *)#>]
                aFailure(nil);
            }
        }
    }];
}

//==============================================================================
- (BOOL) isAuthorized
{
    return [[SCFacebook shared].facebook isSessionValid];
}

//==============================================================================
- (void) getUserInfoSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"Not implement yet");
}

//==============================================================================
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"Not implement yet");
}

@end
