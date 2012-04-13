//
//  DXSEModule.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEntryConfig.h"
#import "MUCocoaExtentions.h"
#import "MUKitDefines.h"

@class DXSEModule;

typedef void (^ DXSESuccessBlock)(DXSEModule *module, id data);
typedef void (^ DXSEFailureBlock)(DXSEModule *module, NSError *error);


@interface DXSEModule : NSObject

@property (nonatomic, readonly, strong) DXSEntryConfig *entryConfig;

- (id)initWithEntryConfig:(DXSEntryConfig *)anInitialConfig;

#pragma mark - Authentication
- (void)login:(DXSESuccessBlock) aSuccess failure:(DXSEFailureBlock)aFailure;
- (void)logout:(DXSESuccessBlock) aSuccess failure:(DXSEFailureBlock)aFailure;
- (BOOL)isAuthorized;
- (NSString *)accessToken;

#pragma mark - UserInfo
- (void)getUserInfo:(DXSESuccessBlock) aSuccess failure:(DXSEFailureBlock)aFailure;
- (void)getUserFriends:(DXSESuccessBlock) aSuccess failure:(DXSEFailureBlock)aFailure;

#pragma mark -
// other

@end


@interface DXSEModule ()

@property (nonatomic, strong) NSMutableDictionary *successBlocks;
@property (nonatomic, strong) NSMutableDictionary *failureBlocks;
@property (nonatomic, readwrite, strong) DXSEntryConfig *entryConfig;

@end


@interface DXSEModule (OnlyForSubclasses)

- (void)showLoginController:(UIViewController *)aLoginController;
- (void)hideLoginController;

- (void)registerSuccessBlock:(DXSESuccessBlock) successBlock forKey:(NSString *)aBlockKey;
- (void)registerFailureBlock:(DXSEFailureBlock) failureBlock forKey:(NSString *)aBlockKey;
- (void)executeSuccessBlockForKey:(NSString *)aBlockKey withData:(id)aData;
- (void)executeFailureBlockForKey:(NSString *)aBlockKey withError:(NSError *)anError;

@end
