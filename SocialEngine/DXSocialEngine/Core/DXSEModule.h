//
//  DXSEModule.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEntryConfig.h"

@class DXSEModule;

typedef void (^DXSESuccessBlock)(DXSEModule* module, id data);
typedef void (^DXSEFailureBlock)(DXSEModule* module, NSError* error);

//==============================================================================
@interface DXSEModule : NSObject
{
    DXSEntryConfig* entryConfig;
}

@property (nonatomic, readonly) DXSEntryConfig* entryConfig;

- (id) initWithEntryConfig:(DXSEntryConfig*) anInitialConfig;

- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
- (void) logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
- (BOOL) isAuthorized;
- (NSString*) accessToken;

- (void) getUserInfoSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
// other

@end
