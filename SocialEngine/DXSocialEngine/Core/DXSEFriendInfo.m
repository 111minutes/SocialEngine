//
//  DXSEFriendInfo.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEFriendInfo.h"

@implementation DXSEFriendInfo

//==============================================================================
@synthesize userID, userName, userAvatorURL;

//==============================================================================
- (void) dealloc
{
    self.userID = nil;
    self.userName = nil;
    self.userAvatorURL = nil;
    [super dealloc];
}

@end
