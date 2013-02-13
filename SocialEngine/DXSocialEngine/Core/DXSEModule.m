//
//  DXSEModule.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEModule.h"

@implementation DXSEModule

@synthesize successBlocks;
@synthesize failureBlocks;

@synthesize entryConfig;
// @synthesize accessToken;

#pragma mark - Init/Dealloc
- (id)init {
    return nil;
}

- (id)initWithEntryConfig:(DXSEntryConfig *)anInitialConfig {
    if ( (self = [super init]) ) {
        self.entryConfig = anInitialConfig;
        NSLog (@"entryConfig: %@", entryConfig);

        self.successBlocks = [NSMutableDictionary dictionary];
        self.failureBlocks = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - Authentication
- (void)login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"You need override this method");
}

- (void)logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"You need override this method");
}

- (BOOL)isAuthorized {
    NSAssert (NO, @"You need override this method");
    return NO;
}

- (NSString *)accessToken {
    NSAssert (NO, @"You need override this method");
    return nil;
}

#pragma mark - UserInfo
- (void)getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"You need override this method");
}

- (void)getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    NSAssert (NO, @"You need override this method");
}

@end

@implementation DXSEModule (OnlyForSubclasses)

- (void)showLoginController:(UIViewController *)aLoginController {
    UIView *view = (UIView *)[UIApplication sharedApplication].keyWindow;

    if ([view.subviews count] > 0) {
        view = [view.subviews objectAtIndex:0];
    }

    UIViewController *controller = [view firstAvailableUIViewController];
    [controller presentModalViewController:aLoginController animated:YES];
}

- (void)hideLoginController {
    UIView *view = (UIView *)[UIApplication sharedApplication].keyWindow;

    if ([view.subviews count] > 0) {
        view = [view.subviews objectAtIndex:0];
    }

    UIViewController *controller = [view firstAvailableUIViewController];
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)registerSuccessBlock:(DXSESuccessBlock)successBlock forKey:(NSString *)aBlockKey {
    if (successBlock && aBlockKey) {
        [successBlocks setObject:[successBlock copy] forKey:aBlockKey];
    }
}

- (void)registerFailureBlock:(DXSEFailureBlock)failureBlock forKey:(NSString *)aBlockKey {
    if (failureBlock && aBlockKey) {
        [failureBlocks setObject:[failureBlock copy] forKey:aBlockKey];
    }
}

- (void)executeSuccessBlockForKey:(NSString *)aBlockKey withData:(id)aData {
    DXSESuccessBlock success = [successBlocks objectForKey:aBlockKey];

    if (success) {
        success (self, aData);
        [successBlocks removeObjectForKey:aBlockKey];        
    }
}

- (void)executeFailureBlockForKey:(NSString *)aBlockKey withError:(NSError *)anError {
    DXSEFailureBlock failure = [failureBlocks objectForKey:aBlockKey];

    if (failure) {
        failure (self, anError);
        [failureBlocks removeObjectForKey:aBlockKey];
    }
}

@end
