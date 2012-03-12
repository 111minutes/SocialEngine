//
//  DXSEFacebook.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEFacebook.h"
#import "SCFacebook.h"
#import "DXSEUserInfoFacebook.h"
#import "MUKitDefines.h"

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

#pragma mark - Authentication
//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [SCFacebook loginCallBack:^(BOOL success, id result)
    {
        if (success)
        {
            aSuccess(self, nil);
//            accessToken = [[SCFacebook shared].facebook.accessToken retain];
        }
        else
        {
            if(result)
            {
//                NSError* error = [[NSError alloc] initWithDomain:<#(NSString *)#> code:<#(NSInteger)#> userInfo:<#(NSDictionary *)#>]
                aFailure(self, nil);
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
        }
        else
        {
            if(result)
            {
//                NSError* error = [[NSError alloc] initWithDomain:<#(NSString *)#> code:<#(NSInteger)#> userInfo:<#(NSDictionary *)#>]
                aFailure(self, nil);
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
- (NSString*) accessToken
{
    return [[SCFacebook shared].facebook accessToken];
}

#pragma mark - UserInfo
//==============================================================================
- (void) getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [SCFacebook getUserFQL:FQL_USER_STANDARD callBack:^(BOOL success, id result)
    {
        if(success)
        {
//            NSLog(@"%@", result);
            DXSEUserInfoFacebook* userInfo = [DXSEUserInfoFacebook userInfo];
            
            userInfo.ID = MU_NULL_PROTECT([result objectForKey:@"uid"]);
            userInfo.name = MU_NULL_PROTECT([result objectForKey:@"name"]);
            userInfo.email = MU_NULL_PROTECT([result objectForKey:@"email"]);
            userInfo.birthdayDate = MU_NULL_PROTECT([result objectForKey:@"birthday_date"]);
            userInfo.avatarURL = [NSURL URLWithString:MU_NULL_PROTECT([result objectForKey:@"pic"])];
            
            aSuccess(self, userInfo);
        }
        else
        {
            aFailure(self, nil);
        }
        
    }];
}

//==============================================================================
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"Not implement yet");
}

@end
