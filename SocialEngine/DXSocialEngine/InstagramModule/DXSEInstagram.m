//
//  DXSEInstagram.m
//  SocialEngine
//
//  Created by Max Mashkov on 4/12/12.
//  Copyright (c) 2012 DIMALEX. All rights reserved.
//

#import "DXSEInstagram.h"

#define LOGIN               @"LOGIN"
#define GET_USER_INFO       @"GET_USER_INFO"

@interface DXSEInstagram ()

@property (nonatomic, strong) WFIGAuthController* signInController;

@end

@implementation DXSEInstagram

@synthesize signInController = _signInController;

#pragma mark - Init/Dealloc
//==============================================================================
- (id) init
{
    return nil;
}

//==============================================================================
- (id) initWithEntryConfig:(DXSEntryConfig *)anInitialConfig
{
    if( (self = [super initWithEntryConfig:anInitialConfig]) )
    {
        [WFInstagramAPI setClientId:self.entryConfig.oauthKey];
        [WFInstagramAPI setClientSecret:self.entryConfig.oauthSecret];
        [WFInstagramAPI setOAuthRedirectURL:self.entryConfig.redirectURL];
    }
    return self;
}

//==============================================================================
- (void) dealloc
{    
    
}

#pragma mark - Authentication
//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [self registerSuccessBlock:aSuccess forKey:LOGIN];
    [self registerFailureBlock:aFailure forKey:LOGIN];
    
    [WFInstagramAPI authenticateUser];
    
//    
//	[[TwitterEngine sharedEngine] requestRequestToken:self onSuccess:@selector(onRequestTokenSuccess:withData:) onFail:@selector(onRequestTokenFailed:withData:)];
//	
//    if([self twitterAccountsExist] == NO){
//        self.signInController = [[OAuthSignInViewController alloc] initWithDelegate:self];
//    }
}

//==============================================================================
- (void) logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
//    [[TwitterEngine sharedEngine] clearAllTwitterCookies];
//    [[TwitterEngine sharedEngine] endUserSession];
//    [[TwitterEngine sharedEngine] clearAccessToken];
    aSuccess(self, nil);
}

//==============================================================================
- (BOOL) isAuthorized
{
//    return [[TwitterEngine sharedEngine] isAuthorized];
}

//==============================================================================
- (NSString*) accessToken
{
//    return [TwitterEngine sharedEngine].accessToken.key;
}

//==============================================================================
- (void) getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
//    if(!_userInfoIdentifier)
//    {
//        [self registerSuccessBlock:aSuccess forKey:GET_USER_INFO];
//        [self registerFailureBlock:aFailure forKey:GET_USER_INFO];
//        
//        if([self twitterAccountsExist]){
//            self.userInfoIdentifier = [[TwitterEngine sharedEngine] getUserInformationFor:[(ACAccount*)[self.twitterAccounts objectAtIndex:0] username]];
//        }
//        else{
//            self.userInfoIdentifier = [[TwitterEngine sharedEngine] getUserInformationFor:[TwitterEngine sharedEngine].username];
//        }
//    }
    //    NSAssert(NO, @"Not implement yet");
}

//==============================================================================
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"Not implement yet");
}

#pragma mark - OAuthSignInViewControllerDelegate
//==============================================================================
- (void) authenticatedWithPin:(NSString *) pin
{
//	TwitterEngine *engine = [TwitterEngine sharedEngine];
//	engine._pin = pin;
	
	//since we got the pin, we can ask for the access token now.
//	[engine requestAccessToken:self onSuccess:@selector(onAccessTokenSuccess:withData:) onFail:@selector(onAccessTokenFailed:withData:)];
    
	// hide login controller here
    [self hideLoginController];
}

//==============================================================================
- (void) authenticationFailed
{
    [self executeFailureBlockForKey:LOGIN withError:nil];
    //    NSAssert(NO, @"Not implement yet");
}

//==============================================================================
- (void) authenticationCanceled
{
	// hide login controller here
    [self hideLoginController];
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

//==============================================================================
- (void) showLoginController:(UIViewController *)aLoginController
{
    [super showLoginController:_signInController];
}

//==============================================================================
- (void) hideLoginController
{
    [super hideLoginController];
    self.signInController = nil;
}


#pragma mark - UserInfo
//==============================================================================
- (void)userInfoReceived:(NSArray *)aUserInfo forRequest:(NSString *)connectionIdentifier
{
//    if(![connectionIdentifier isEqualToString:_userInfoIdentifier])
//    {
//        [self executeFailureBlockForKey:GET_USER_INFO withError:nil];
//        return;
//    }
    
//    self.userInfoIdentifier = nil;
    
//    NSDictionary* userDict = [aUserInfo lastObject];
//    
//    DXSEUserInfoTwitter* userInfo = [DXSEUserInfoTwitter userInfoTwitter];
//    userInfo.ID = [((NSNumber*)MU_NULL_PROTECT([userDict objectForKey:@"id"])) stringValue];
//    userInfo.name = MU_NULL_PROTECT([userDict objectForKey:@"name"]);
//    userInfo.screenName = MU_NULL_PROTECT([userDict objectForKey:@"screen_name"]);
//    
//    [self executeSuccessBlockForKey:GET_USER_INFO withData:userInfo];
    //    NSLog(@"Twitter - UserInfo:\n%@", aUserInfo);
    
}


@end
