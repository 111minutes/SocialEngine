//
//  DXSETwitter.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEModule.h"
#import "MGTwitterEngineDelegate.h"
#import "OAuthSignInViewController.h"


@interface DXSETwitter : DXSEModule <OAuthSignInViewControllerDelegate, MGTwitterEngineDelegate>
{
	OAuthSignInViewController* signInController;
    
    DXSESuccessBlock postSuccessBlock;
    DXSEFailureBlock postFailureBlock;
    
    NSString *userInfoIdentifier;
}

- (NSString *)accessSecret;

@end
