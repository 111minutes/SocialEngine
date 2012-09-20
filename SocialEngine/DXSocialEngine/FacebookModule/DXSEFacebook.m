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
#import "DXSESocialEngine.h"

#define LOGIN               @"LOGIN"
#define GET_USER_INFO       @"GET_USER_INFO"

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
        
        //Notification
        [[NSNotificationCenter defaultCenter] addObserverForName:DXSE_REMOVE_FACEBOOK_LOGIN_BLOC
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note)
        {
            DXSESuccessBlock aFailer = [failureBlocks objectForKey:LOGIN];
            if (aFailer) {
                aFailer(self, nil);
                [self removeBlockForKey:LOGIN];
            }
        }];
    }
    return self;
}

#pragma mark - Authentication
//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [self registerSuccessBlock:aSuccess forKey:LOGIN];
    [self registerFailureBlock:aFailure forKey:LOGIN];
    
    [SCFacebook loginCallBack:^(BOOL success, id result)
    {
        if (success)
        {
            if (aSuccess)
            {
                aSuccess(self, nil);
                [self removeBlockForKey:LOGIN];
            }
        }
        else
        {
            if (aFailure)
            {
                aFailure(self, nil);
                [self removeBlockForKey:LOGIN];
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
            if (aSuccess)
                aSuccess(self, nil);
        }
        else
        {
            if(aFailure)
                aFailure(self, nil);
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
            DXSEUserInfoFacebook* userInfo = [DXSEUserInfoFacebook userInfo];
            
            userInfo.ID = MU_NULL_PROTECT([result objectForKey:@"uid"]);
            userInfo.name = MU_NULL_PROTECT([result objectForKey:@"name"]);
            userInfo.email = MU_NULL_PROTECT([result objectForKey:@"email"]);
            userInfo.birthdayDate = MU_NULL_PROTECT([result objectForKey:@"birthday_date"]);
            userInfo.avatarURL = [NSURL URLWithString:MU_NULL_PROTECT([result objectForKey:@"pic"])];
            
            if (aSuccess)
                aSuccess(self, userInfo);
        }
        else
        {
            if (aFailure)
                aFailure(self, nil);
        }
        
    }];
}

//==============================================================================
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"Not implement yet");
}

- (void) postURL:(NSURL *)aURL andCaption:(NSString*)aCaption withSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    
    [SCFacebook feedPostWithLinkPath:[aURL absoluteString] caption:aCaption callBack:^(BOOL success, id result) {
        if (success) {
            if (aSuccess) {
                aSuccess(self, result);
            }
        }
        else {
            if (aFailure) {
                aFailure(self, nil);
            }
        }
    }];
}

@end
