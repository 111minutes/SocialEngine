//
//  DXSETwitter.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import "DXSETwitter.h"
#import "MGTwitterEngine.h"
#import "TwitterEngine.h"
#import "DXSEUserInfoTwitter.h"

#define LOGIN         @"LOGIN"
#define GET_USER_INFO @"GET_USER_INFO"

#define IOS_VERSION_5 (NSClassFromString (@"ACAccount") != NULL)

@interface DXSETwitter ()

@property (nonatomic, strong) OAuthSignInViewController *signInController;
@property (nonatomic, strong) NSString *userInfoIdentifier;
@property (nonatomic, strong) NSArray *twitterAccounts;

@end

@interface DXSETwitter (iOS5)

- (BOOL)twitterAccountsExist;
- (void)requestAccessToTwitter;

@end

@implementation DXSETwitter

@synthesize signInController = _signInController;
@synthesize userInfoIdentifier = _userInfoIdentifier;
@synthesize twitterAccounts = _twitterAccounts;

#pragma mark - Init/Dealloc
- (id)init {
    return nil;
}

- (id)initWithEntryConfig:(DXSEntryConfig *)anInitialConfig {
    if ( (self = [super initWithEntryConfig:anInitialConfig]) ) {
        [TwitterEngine sharedEngineWithDelegate:self];
        [[TwitterEngine sharedEngine] setConsumerKey:self.entryConfig.oauthKey secret:self.entryConfig.oauthSecret];
    }
    return self;
}

- (void)dealloc {
}

#pragma mark - Authentication
- (void)login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    [self registerSuccessBlock:aSuccess forKey:LOGIN];
    [self registerFailureBlock:aFailure forKey:LOGIN];

    [[TwitterEngine sharedEngine] requestRequestToken:self onSuccess:@selector(onRequestTokenSuccess:withData:) onFail:@selector(onRequestTokenFailed:withData:)];

    if ([self twitterAccountsExist] == NO) {
        self.signInController = [[OAuthSignInViewController alloc] initWithDelegate:self];
    }
}

- (void)logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    [[TwitterEngine sharedEngine] clearAllTwitterCookies];
    [[TwitterEngine sharedEngine] endUserSession];
    [[TwitterEngine sharedEngine] clearAccessToken];
    aSuccess (self, nil);
}

- (BOOL)isAuthorized {
    return [[TwitterEngine sharedEngine] isAuthorized];
}

- (NSString *)accessToken {
    return [TwitterEngine sharedEngine].accessToken.key;
}

- (void)getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    if (!_userInfoIdentifier) {
        [self registerSuccessBlock:aSuccess forKey:GET_USER_INFO];
        [self registerFailureBlock:aFailure forKey:GET_USER_INFO];

        if ([self twitterAccountsExist]) {
            self.userInfoIdentifier = [[TwitterEngine sharedEngine] getUserInformationFor:[(ACAccount *)[self.twitterAccounts objectAtIndex:0] username]];
        } else {
            self.userInfoIdentifier = [[TwitterEngine sharedEngine] getUserInformationFor:[TwitterEngine sharedEngine].username];
        }
    }
//    NSAssert(NO, @"Not implement yet");
}

- (void)getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"Not implement yet");
}

#pragma mark - OAuthSignInViewControllerDelegate
- (void)authenticatedWithPin:(NSString *)pin {
    TwitterEngine *engine = [TwitterEngine sharedEngine];

    engine._pin = pin;

    // since we got the pin, we can ask for the access token now.
    [engine requestAccessToken:self onSuccess:@selector(onAccessTokenSuccess:withData:) onFail:@selector(onAccessTokenFailed:withData:)];

    // hide login controller here
    [self hideLoginController];
}

- (void)authenticationFailed {
    [self executeFailureBlockForKey:LOGIN withError:nil];
//    NSAssert(NO, @"Not implement yet");
}

- (void)authenticationCanceled {
    // hide login controller here
    [self hideLoginController];
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

#pragma mark - oAuth delegate
- (void)onRequestTokenSuccess:(OAServiceTicket *)ticket withData:(NSData *)data {
    TwitterEngine *sharedEngine = [TwitterEngine sharedEngine];

    [sharedEngine setRequestToken:ticket withData:data];

    if ([self twitterAccountsExist]) {
        [self requestAccessToTwitter];
    } else {
        // now we can start the sign in process.
        [_signInController loadRequest:[sharedEngine authorizeURLRequest]];

        // show login controller here
        [self showLoginController:_signInController];
    }
}

- (void)onRequestTokenFailed:(OAServiceTicket *)ticket withData:(NSData *)data {
    NSLog (@"Twitter: Request token failed");
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

- (void)onAccessTokenSuccess:(OAServiceTicket *)ticket withData:(NSData *)data {
    if (ticket.didSucceed) {
        [[TwitterEngine sharedEngine] setAccessTokenWith:ticket withData:data];
        [self executeSuccessBlockForKey:LOGIN withData:nil];
    } else {
        NSLog (@"Twitter: Access token failed");
        [self executeFailureBlockForKey:LOGIN withError:nil];
    }
}

- (void)onAccessTokenFailed:(OAServiceTicket *)ticket withData:(NSData *)data {
    NSLog (@"Twitter: Access token failed");
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

- (void)showLoginController:(UIViewController *)aLoginController {
    [super showLoginController:_signInController];
}

- (void)hideLoginController {
    [super hideLoginController];
    self.signInController = nil;
}

#pragma mark - MGTwitterEngineDelegate
- (void)requestSucceeded:(NSString *)connectionIdentifier;
{
    // ...
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    // ...
}

#pragma mark - UserInfo
- (void)userInfoReceived:(NSArray *)aUserInfo forRequest:(NSString *)connectionIdentifier {
    if (![connectionIdentifier isEqualToString:_userInfoIdentifier]) {
        [self executeFailureBlockForKey:GET_USER_INFO withError:nil];
        return;
    }

    self.userInfoIdentifier = nil;

    NSDictionary *userDict = [aUserInfo lastObject];

    DXSEUserInfoTwitter *userInfo = [DXSEUserInfoTwitter userInfoTwitter];
    userInfo.ID = [((NSNumber *)MU_NULL_PROTECT ([userDict objectForKey:@"id"]))stringValue];
    userInfo.name = MU_NULL_PROTECT ([userDict objectForKey:@"name"]);
    userInfo.screenName = MU_NULL_PROTECT ([userDict objectForKey:@"screen_name"]);

    [self executeSuccessBlockForKey:GET_USER_INFO withData:userInfo];
//    NSLog(@"Twitter - UserInfo:\n%@", aUserInfo);
}

@end


@implementation DXSETwitter (iOS5)

- (BOOL)twitterAccountsExist {
    if (IOS_VERSION_5) {
        ACAccountStore *accountStore = [ACAccountStore new];
        ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

        NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountTypeTwitter];

        return [twitterAccounts objectAtIndex:0] != nil;
    }

    return NO;
}

- (void)requestAccessToTwitter {
    if ([self twitterAccountsExist]) {
        __block ACAccountStore *accountStore = [ACAccountStore new];
        __block ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

        void (^successBlock)(void) = ^{
            self.twitterAccounts = [accountStore accountsWithAccountType:accountTypeTwitter];
            [self executeSuccessBlockForKey:LOGIN withData:nil];
        };

        if ([accountTypeTwitter accessGranted]) {
            successBlock ();
        } else {
            [accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError * error) {
                 if (granted) {
                     successBlock ();
                 } else {
                     [self executeFailureBlockForKey:LOGIN withError:nil];
                 }
             }];
        }
    }
}

@end
