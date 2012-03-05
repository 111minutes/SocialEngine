//
//  DXSEModule.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEInitialConfig.h"

typedef void (^DXSESuccessBlock)(id data);
typedef void (^DXSEFailureBlock)(NSError* error);

//==============================================================================
@interface DXSEModule : NSObject
{
    DXSEInitialConfig* initialConfig;
    
    NSString* accessToken;
}

@property (nonatomic, readonly) DXSEInitialConfig* initialConfig;
@property (nonatomic, readonly) NSString* accessToken;

- (id) initWithInitialConfig:(DXSEInitialConfig*) anInitialConfig;

- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
- (void) logout;
- (BOOL) isAuthorized;
- (void) getUserInfoSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
// other

@end
