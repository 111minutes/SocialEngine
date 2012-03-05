//
//  DXSEUserInfo.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@implementation DXSEUserInfo

//==============================================================================
@synthesize userID, userName, userEmail, userAvatarURL, userBirthdayDate;

//==============================================================================
- (void) dealloc
{
    self.userID = nil;
    self.userName = nil;
    self.userEmail = nil;
    self.userAvatarURL = nil;
    self.userBirthdayDate = nil;
    
    [super dealloc];
}

@end
