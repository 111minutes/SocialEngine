//
//  DXSEUserInfo.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfoFacebook.h"

@implementation DXSEUserInfoFacebook

@synthesize name, email, avatarURL, birthdayDate;

//==============================================================================
+ (id) userInfo
{
    return [[[DXSEUserInfoFacebook alloc] init] autorelease];
}

//==============================================================================
- (void) dealloc
{
    [name release];
    [email release];
    [avatarURL release];
    [birthdayDate release];
    
    [super dealloc];
}

//==============================================================================
- (NSString*) description
{
    return [NSString stringWithFormat:@"id=%@; name=%@; email=%@; birthdate=%@; avatarURL=%@",
            self.ID, name, email, birthdayDate, avatarURL];
}

@end
