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

#define DXSE_OPEN_URL @ "OPEN_URL"

@interface DXSESocialEngine : NSObject
{
}

@property (nonatomic, readonly, strong) DXSEFacebook *facebook;
@property (nonatomic, readonly, strong) DXSETwitter *twitter;
@property (nonatomic, readonly, strong) DXSE4Square *fourSquare;
@property (nonatomic, readonly, strong) DXSEInstagram *instagram;

+ (DXSESocialEngine *)sharedInstance;

- (DXSEModule *)firstAuthorizedModule;

@end
