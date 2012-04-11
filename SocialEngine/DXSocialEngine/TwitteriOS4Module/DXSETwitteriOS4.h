//
//  DXSETwitter.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSETwitter.h"
#import "MGTwitterEngineDelegate.h"
#import "OAuthSignInViewController.h"


@interface DXSETwitteriOS4 : DXSETwitter <OAuthSignInViewControllerDelegate, MGTwitterEngineDelegate>

@end
