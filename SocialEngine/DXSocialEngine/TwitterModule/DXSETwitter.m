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
#include "MUCocoaExtentions.h"

//==============================================================================
//==============================================================================
//==============================================================================
@interface DXSETwitter (Private)

- (void) showLoginController;
- (void) hideLoginController;

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
        [[TwitterEngine sharedEngine] setConsumerKey:entryConfig.oauthKey secret:entryConfig.oauthSecret];
    }
    return self;
}

//==============================================================================
- (void) dealloc
{
    [successBlock release];
    [failureBlock release];
    
    [super dealloc];
}

//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    [successBlock release];
    [failureBlock release];
    successBlock = [aSuccess retain];
    failureBlock = [aFailure retain];

	[[TwitterEngine sharedEngine] requestRequestToken:self onSuccess:@selector(onRequestTokenSuccess:withData:) onFail:@selector(onRequestTokenFailed:withData:)];
	
	signInController = [[OAuthSignInViewController alloc] initWithDelegate:self];
}

//==============================================================================
- (void) logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"Not implement yet");
}

//==============================================================================
- (BOOL) isAuthorized
{
    return [[TwitterEngine sharedEngine] isAuthorized];
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
    failureBlock(nil);
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
    failureBlock(nil);
	
	//TODO: add your own error handling here.
}

//==============================================================================
- (void) onAccessTokenSuccess:(OAServiceTicket *)ticket withData:(NSData *)data
{
	[[TwitterEngine sharedEngine] setAccessTokenWith:ticket withData:data];
    successBlock(nil, nil);
}

//==============================================================================
- (void) onAccessTokenFailed:(OAServiceTicket *)ticket withData:(NSData *)data
{
	NSLog(@"Twitter: Access token failed");
    failureBlock(nil);
	
	//TODO: add your own error handling here.
}

//==============================================================================
- (void) showLoginController
{
    UIView* view = (UIView*)[UIApplication sharedApplication].keyWindow;
    UIViewController* controller = [view firstAvailableUIViewController];
    [controller presentModalViewController:signInController animated:YES];
}

//==============================================================================
- (void) hideLoginController
{
    UIViewController* controller = [(UIView*)[UIApplication sharedApplication].keyWindow firstAvailableUIViewController];
    [controller dismissModalViewControllerAnimated:YES];
    [signInController autorelease];
    signInController = nil;
}

@end
