//
//  DXSEInstagram.m
//  SocialEngine
//
//  Created by Max Mashkov on 4/12/12.
//  Copyright (c) 2012 DIMALEX. All rights reserved.
//

#import "DXSESocialEngine.h"
#import "DXSEInstagram.h"
#import "DXSEUserInfoInstagram.h"

#define LOGIN         @"LOGIN"
#define GET_USER_INFO @"GET_USER_INFO"

@interface DXSEInstagram ()

@property (nonatomic, strong) WFIGAuthController *signInController;

- (void)didRecieveURLNotification:(NSNotification *)notification;
- (void)didEnterAuthNotification:(NSNotification *)notification;
- (void)didCancelAuthNotification:(NSNotification *)notification;

@end

@implementation DXSEInstagram

@synthesize signInController = _signInController;

#pragma mark - Init/Dealloc
- (id)init {
    return nil;
}

- (id)initWithEntryConfig:(DXSEntryConfig *)anInitialConfig {
    if ( (self = [super initWithEntryConfig:anInitialConfig]) ) {
        [WFInstagramAPI setClientId:self.entryConfig.oauthKey];
        [WFInstagramAPI setClientSecret:self.entryConfig.oauthSecret];
        [WFInstagramAPI setOAuthRedirectURL:self.entryConfig.redirectURL];

        [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(didRecieveURLNotification:)
         name:DXSE_OPEN_URL
         object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(didEnterAuthNotification:)
         name:DidEnterAuthNotification
         object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(didCancelAuthNotification:)
         name:DidCancelAuthNotification
         object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showLoginController:(UIViewController *)aLoginController {
    [super showLoginController:aLoginController];
}

- (void)hideLoginController {
    [super hideLoginController];
}

#pragma mark - Authentication
- (void)login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    [self registerSuccessBlock:aSuccess forKey:LOGIN];
    [self registerFailureBlock:aFailure forKey:LOGIN];

    [WFInstagramAPI authenticateUser];
}

- (void)logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"Not implemented yet");
}

- (BOOL)isAuthorized {
    return [WFInstagramAPI currentUser] != nil;
}

- (NSString *)accessToken {
    return [WFInstagramAPI accessToken];
}

- (void)getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    [self registerSuccessBlock:aSuccess forKey:GET_USER_INFO];
    [self registerFailureBlock:aFailure forKey:GET_USER_INFO];

    WFIGUser *currentUser = [WFInstagramAPI currentUser];

    if (currentUser) {
        DXSEUserInfoInstagram *userInfo = [DXSEUserInfoInstagram userInfoInstagram];

        userInfo.username = MU_NULL_PROTECT (currentUser.username);
        userInfo.instagramId = MU_NULL_PROTECT (currentUser.instagramId);
        userInfo.profilePicture = MU_NULL_PROTECT (currentUser.profilePicture);
        userInfo.website = MU_NULL_PROTECT (currentUser.website);
        userInfo.fullName = MU_NULL_PROTECT (currentUser.fullName);
        userInfo.bio = MU_NULL_PROTECT (currentUser.bio);
        userInfo.followedByCount = MU_NULL_PROTECT (currentUser.followedByCount);
        userInfo.followsCount = MU_NULL_PROTECT (currentUser.followsCount);
        userInfo.mediaCount = MU_NULL_PROTECT (currentUser.mediaCount);

        [self executeSuccessBlockForKey:GET_USER_INFO withData:userInfo];
    } else {
        [self executeFailureBlockForKey:GET_USER_INFO withError:nil];
    }
}

- (void)getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"Not implemented yet");
}

- (void)didRecieveURLNotification:(NSNotification *)notification {
    NSURL *recievedURL = (NSURL *)notification.object;
    
    if ([recievedURL.description rangeOfString:self.entryConfig.redirectURL].location != NSNotFound)
    {
        NSDictionary *params = [recievedURL queryDictionary];

        if ([params objectForKey:@"code"]) {
            WFIGResponse *response = [WFInstagramAPI accessTokenForCode:[params objectForKey:@"code"]];
            NSDictionary *json = [response parsedBody];
            [WFInstagramAPI setAccessToken:[json objectForKey:@"access_token"]];

            [self hideLoginController];

            [self executeSuccessBlockForKey:LOGIN withData:nil];
        } else {
            [self hideLoginController];

            [self executeFailureBlockForKey:LOGIN withError:nil];
        }
    }
}

- (void)didEnterAuthNotification:(NSNotification *)notification {
    UIViewController *authController = (UIViewController *)notification.object;

    [self showLoginController:authController];
}

- (void)didCancelAuthNotification:(NSNotification *)notification {
    [self hideLoginController];
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

@end
