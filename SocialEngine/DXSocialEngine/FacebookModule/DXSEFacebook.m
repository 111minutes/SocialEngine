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
- (void) logout
{
    [SCFacebook logoutCallBack:^(BOOL success, id result)
    {
        // ...
    }];
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
