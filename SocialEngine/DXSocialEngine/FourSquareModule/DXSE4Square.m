//
//  DXSE4Square.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSE4Square.h"
#import "Foursquare2.h"
#import "DXSEUserInfo4Square.h"


#define LOGIN @"LOGIN"

@interface DXSE4Square (Private)

- (void)setCode:(NSString *)aCode;
- (void)clearAll4SquareCookies;

@end

@implementation DXSE4Square

#pragma mark - Init/Dealloc
- (id)init {
    return nil;
}

- (id)initWithEntryConfig:(DXSEntryConfig *)anInitialConfig {
    if ( (self = [super initWithEntryConfig:anInitialConfig]) ) {
        [Foursquare2 setOAuthKey:self.entryConfig.oauthKey secret:self.entryConfig.oauthSecret redirectURL:self.entryConfig.redirectURL];
    }
    return self;
}

- (void)clearAll4SquareCookies{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        if ([[cookie domain] rangeOfString:@"foursquare.com"].location != NSNotFound) {
            [cookieStorage deleteCookie:cookie];
        }
    }
}

#pragma mark - Authentication
- (void)login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    [self registerSuccessBlock:aSuccess forKey:LOGIN];
    [self registerFailureBlock:aFailure forKey:LOGIN];

    NSString *url = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?display=touch&client_id=%@&response_type=code&redirect_uri=%@", self.entryConfig.oauthKey, self.entryConfig.redirectURL];
    FoursquareWebLogin *webLoginController = [[FoursquareWebLogin alloc] initWithUrl:url];
    webLoginController.delegate = self;
    webLoginController.selector = @selector(setCode:);

    [self showLoginController:webLoginController];
}

- (void)logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    [Foursquare2 removeAccessToken];
    [self clearAll4SquareCookies];
    aSuccess (self, nil);
}

- (BOOL)isAuthorized {
    return ![Foursquare2 isNeedToAuthorize];
}

- (NSString *)accessToken {
    return [Foursquare2 accessToken];
}

- (void)setCode:(NSString *)aCode {
    [Foursquare2 getAccessTokenForCode:aCode callback:^(BOOL success, id result)
     {
         [Foursquare2 setBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]];

         if (success) {
             [Foursquare2 setAccessToken:[result objectForKey:@"access_token"]];
             [self executeSuccessBlockForKey:LOGIN withData:nil];
         } else {
             [self executeFailureBlockForKey:LOGIN withError:nil];
         }
     }];
}

#pragma mark - UserInfo
- (void)getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    [Foursquare2 getDetailForUser:@"self" callback:^(BOOL success, id result)
     {
         if (success) {
             NSLog (@"\n-------\n%@", result);

             DXSEUserInfo4Square *userInfo = [DXSEUserInfo4Square userInfo4Square];

             NSDictionary *userDict = [[result objectForKey:@"response"] objectForKey:@"user"];

             userInfo.ID = MU_NULL_PROTECT ([userDict objectForKey:@"id"]);
             userInfo.firstName = MU_NULL_PROTECT ([userDict objectForKey:@"firstName"]);
             userInfo.lastName = MU_NULL_PROTECT ([userDict objectForKey:@"lastName"]);
             userInfo.avatarURL = MU_NULL_PROTECT ([userDict objectForKey:@"photo"]);

             NSDictionary *contactDict = MU_NULL_PROTECT ([userDict objectForKey:@"contact"]);
             if (contactDict) {
                 userInfo.email = MU_NULL_PROTECT ([contactDict objectForKey:@"email"]);
             }

             aSuccess (self, userInfo);
         } else {
             aFailure (self, nil);
         }
     }];
}

- (void)getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"You need override this method");
}

#pragma mark - FoursquareWebLoginDelegate
- (void)foursquareWebLoginWasCanceled:(FoursquareWebLogin *)aWebLogin {
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

@end
