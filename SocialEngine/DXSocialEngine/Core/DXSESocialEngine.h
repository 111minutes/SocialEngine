//
//  DXSocialEngine.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEFacebook.h"
#import "DXSETwitter.h"
#import "DXSE4Square.h"
#import "DXSEInstagram.h"

#define DXSE_OPEN_URL @"OPEN_URL"
#define DXSE_REMOVE_FACEBOOK_LOGIN_BLOC @"DXSE_REMOVE_FACEBOOK_LOGIN_BLOC"

@interface DXSESocialEngine : NSObject
{
}

@property (nonatomic, readonly) DXSEFacebook* facebook;
@property (nonatomic, readonly) DXSETwitter* twitter;
@property (nonatomic, readonly) DXSE4Square* fourSquare;
@property (nonatomic, readonly) DXSEInstagram *instagram;

+ (DXSESocialEngine*) sharedInstance;

- (DXSEModule *) firstAuthorizedModule;

- (void) configure;
- (void) configureWithDictionary:(NSDictionary *)config;

@end
