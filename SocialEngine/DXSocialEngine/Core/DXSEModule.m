//
//  DXSEModule.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEModule.h"

@implementation DXSEModule

@synthesize entryConfig;
//@synthesize accessToken;

#pragma mark - Init/Dealloc
//==============================================================================
- (id) init
{
    [self release];
    return nil;
}

//==============================================================================
- (id) initWithEntryConfig:(DXSEntryConfig*) anInitialConfig
{
    if( (self = [super init]) )
    {
        entryConfig = [anInitialConfig retain];
        NSLog(@"entryConfig: %@", entryConfig);

        successBlocks = [NSMutableDictionary new];
        failureBlocks = [NSMutableDictionary new];
    }
    return self;
}

//==============================================================================
- (void) dealloc
{
    [entryConfig release];
    [successBlocks release];
    [failureBlocks release];
    
    [super dealloc];
}

#pragma mark - Authentication
//==============================================================================
- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

//==============================================================================
- (void) logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

//==============================================================================
- (BOOL) isAuthorized
{
    NSAssert(NO, @"You need override this method");
    return NO;
}

//==============================================================================
- (NSString*) accessToken
{
    NSAssert(NO, @"You need override this method");
    return nil;
}

#pragma mark - UserInfo
//==============================================================================
- (void) getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

//==============================================================================
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure
{
    NSAssert(NO, @"You need override this method");
}

@end

//==============================================================================
//==============================================================================
//==============================================================================
@implementation DXSEModule (OnlyForSubclasses)

//==============================================================================
- (void) showLoginController:(UIViewController*)aLoginController
{
    UIView* view = (UIView*)[UIApplication sharedApplication].keyWindow;
    if([view.subviews count] > 0)
        view = [view.subviews objectAtIndex:0];
    
    UIViewController* controller = [view firstAvailableUIViewController];
    [controller presentModalViewController:aLoginController animated:YES];
}

//==============================================================================
- (void) hideLoginController
{
    UIView* view = (UIView*)[UIApplication sharedApplication].keyWindow;
    if([view.subviews count] > 0)
        view = [view.subviews objectAtIndex:0];
    
    UIViewController* controller = [view firstAvailableUIViewController];
    [controller dismissModalViewControllerAnimated:YES];
}

//==============================================================================
- (void) registerSuccessBlock:(DXSESuccessBlock)successBlock forKey:(NSString*)aBlockKey
{
    [successBlocks setObject:[[successBlock copy] autorelease] forKey:aBlockKey];
}

//==============================================================================
- (void) registerFailureBlock:(DXSEFailureBlock)failureBlock forKey:(NSString*)aBlockKey
{
    [failureBlocks setObject:[[failureBlock copy] autorelease] forKey:aBlockKey];
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