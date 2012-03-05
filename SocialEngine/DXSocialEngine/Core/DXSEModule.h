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
@protocol DXSEModuleProtocol <NSObject>

- (void) login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
- (void) logout;
- (void) getUserInfoSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
- (void) getUserFriends:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;
// other

@end

//==============================================================================
@interface DXSEModule : NSObject <DXSEModuleProtocol>
{
    DXSEInitialConfig* initialConfig;
}

@property (nonatomic, readonly) DXSEInitialConfig* initialConfig;

- (id) initWithInitialConfig:(DXSEInitialConfig*) anInitialConfig;

@end
