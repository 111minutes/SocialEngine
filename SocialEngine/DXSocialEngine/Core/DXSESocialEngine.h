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

@interface DXSESocialEngine : NSObject
{
}

@property (nonatomic, readonly) DXSEFacebook* facebook;
@property (nonatomic, readonly) DXSETwitter* twitter;
@property (nonatomic, readonly) DXSE4Square* fourSquare;

+ (DXSESocialEngine*) sharedInstance;


@end
