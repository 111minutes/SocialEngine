//
//  DXSETwitter.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSETwitter.h"
#import "MGTwitterEngine.h"
#import "TwitterEngine.h"
#import "DXSEUserInfoTwitter.h"
#include "MUCocoaExtentions.h"
#import "MUKitDefines.h"

#define LOGIN               @"LOGIN"
#define GET_USER_INFO       @"GET_USER_INFO"

//==============================================================================
//==============================================================================
//==============================================================================
@interface DXSETwitter (Private)

- (void) showLoginController;
- (void) hideLoginController;

- (void) registerSuccessBlock:(DXSESuccessBlock)successBlock forKey:(NSString*)aBlockKey;
- (void) registerFailureBlock:(DXSEFailureBlock)failureBlock forKey:(NSString*)aBlockKey;
- (void) executeSuccessBlockForKey:(NSString*)aBlockKey withData:(id)aData;
- (void) executeFailureBlockForKey:(NSString*)aBlockKey withError:(NSError*)anError;

@end

//==============================================================================
//==============================================================================
//==============================================================================
@implementation DXSETwitter

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
        successBlocks = [NSMutableDictionary new];
        failureBlocks = [NSMutableDictionary new];
        
        [TwitterEngine sharedEngineWithDelegate:self];
        [[TwitterEngine sharedEngine] setConsumerKey:entryConfig.oauthKey secret:entryConfig.oauthSecret];
    }
    return self;
}

//==============================================================================
- (void) dealloc
{
    [successBlocks release];
    [failureBlocks release];
    
    [userInfoIdentifier release];

    [super dealloc];
}

//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [self registerSuccessBlock:aSuccess forKey:LOGIN];
    [self registerFailureBlock:aFailure forKey:LOGIN];

	[[TwitterEngine sharedEngine] requestRequestToken:self onSuccess:@selector(onRequestTokenSuccess:withData:) onFail:@selector(onRequestTokenFailed:withData:)];
	
	signInController = [[OAuthSignInViewController alloc] initWithDelegate:self];
}

//==============================================================================
- (void) logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [[TwitterEngine sharedEngine] endUserSession];
//    [[TwitterEngine sharedEngine] clearAccessToken];
    aSuccess(self, nil);
}

//==============================================================================
- (BOOL) isAuthorized
{
    return [[TwitterEngine sharedEngine] isAuthorized];
}

//==============================================================================
- (NSString*) accessToken
{
    return [TwitterEngine sharedEngine].accessToken.key;
}

//==============================================================================
- (void) getUserInfoSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    if(!userInfoIdentifier)
    {
        [self registerSuccessBlock:aSuccess forKey:GET_USER_INFO];
        [self registerFailureBlock:aFailure forKey:GET_USER_INFO];
        userInfoIdentifier = [[TwitterEngine sharedEngine] getUserInformationFor:[TwitterEngine sharedEngine].username];
        [userInfoIdentifier retain];
    }
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
	TwitterEngine *engine = [TwitterEngine sharedEngine];
	engine._pin = pin;
	
	//since we got the pin, we can ask for the access token now.
	[engine requestAccessToken:self onSuccess:@selector(onAccessTokenSuccess:withData:) onFail:@selector(onAccessTokenFailed:)];

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
}

#pragma mark - oAuth delegate
//==============================================================================
- (void) onRequestTokenSuccess:(OAServiceTicket *)ticket withData:(NSData *)data
{
	TwitterEngine* sharedEngine = [TwitterEngine sharedEngine];
	[sharedEngine setRequestToken:ticket withData:data];
	
	//now we can start the sign in process.
	[signInController loadRequest:[sharedEngine authorizeURLRequest]];
    
    // show login controller here
    [self showLoginController];
}

//==============================================================================
- (void) onRequestTokenFailed:(OAServiceTicket *)ticket withData:(NSData *)data
{
	NSLog(@"Twitter: Request token failed");
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

//==============================================================================
- (void) onAccessTokenSuccess:(OAServiceTicket *)ticket withData:(NSData *)data
{
	[[TwitterEngine sharedEngine] setAccessTokenWith:ticket withData:data];
    [self executeSuccessBlockForKey:LOGIN withData:nil];
}

//==============================================================================
- (void) onAccessTokenFailed:(OAServiceTicket *)ticket withData:(NSData *)data
{
	NSLog(@"Twitter: Access token failed");
    [self executeFailureBlockForKey:LOGIN withError:nil];
}

//==============================================================================
- (void) showLoginController
{
    UIView* view = (UIView*)[UIApplication sharedApplication].keyWindow;
    if([view.subviews count] > 0)
        view = [view.subviews objectAtIndex:0];
    
    UIViewController* controller = [view firstAvailableUIViewController];
    [controller presentModalViewController:signInController animated:YES];
    [signInController autorelease];
}

//==============================================================================
- (void) hideLoginController
{
    UIView* view = (UIView*)[UIApplication sharedApplication].keyWindow;
    if([view.subviews count] > 0)
        view = [view.subviews objectAtIndex:0];
    
    UIViewController* controller = [view firstAvailableUIViewController];
    [controller dismissModalViewControllerAnimated:YES];
    signInController = nil;
}

#pragma mark - MGTwitterEngineDelegate
//==============================================================================
- (void)requestSucceeded:(NSString *)connectionIdentifier;
{
    // ...
}

//==============================================================================
- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    // ...
}

//==============================================================================
- (void)userInfoReceived:(NSArray *)aUserInfo forRequest:(NSString *)connectionIdentifier
{
    if(![connectionIdentifier isEqualToString:userInfoIdentifier])
    {
        [self executeFailureBlockForKey:GET_USER_INFO withError:nil];
        return;
    }
    
    [userInfoIdentifier release];
    userInfoIdentifier = nil;
    
    NSDictionary* userDict = [aUserInfo lastObject];
    
    DXSEUserInfoTwitter* userInfo = [DXSEUserInfoTwitter userInfoTwitter];
    userInfo.ID = [((NSNumber*)NULL_PROTECT([userDict objectForKey:@"id"])) stringValue];
    userInfo.name = NULL_PROTECT([userDict objectForKey:@"name"]);
    userInfo.screenName = NULL_PROTECT([userDict objectForKey:@"screen_name"]);
    
    [self executeSuccessBlockForKey:GET_USER_INFO withData:userInfo];
//    NSLog(@"Twitter - UserInfo:\n%@", aUserInfo);
    
}

//==============================================================================
- (void) registerSuccessBlock:(DXSESuccessBlock)successBlock forKey:(NSString*)aBlockKey
{
    [successBlocks setObject:successBlock forKey:aBlockKey];
}

//==============================================================================
- (void) registerFailureBlock:(DXSEFailureBlock)failureBlock forKey:(NSString*)aBlockKey
{
    [failureBlocks setObject:failureBlock forKey:aBlockKey];
}

//==============================================================================
- (void) executeSuccessBlockForKey:(NSString*)aBlockKey withData:(id)aData
{
    DXSESuccessBlock success = [successBlocks objectForKey:aBlockKey];
    success(self, aData);
    [successBlocks removeObjectForKey:aBlockKey];
}

//==============================================================================
- (void) executeFailureBlockForKey:(NSString*)aBlockKey withError:(NSError*)anError
{
    DXSEFailureBlock failure = [failureBlocks objectForKey:aBlockKey];
    failure(self, anError);
    [failureBlocks removeObjectForKey:aBlockKey];
}

@end
