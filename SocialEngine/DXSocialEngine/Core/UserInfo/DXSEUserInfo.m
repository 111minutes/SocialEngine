//
//  DXSEUserInfo.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@implementation DXSEUserInfo

@synthesize ID, name, email, avatarURL, birthdayDate;

//==============================================================================
+ (id) userInfo
{
    return [[[DXSEUserInfo alloc] init] autorelease];
}

//==============================================================================
- (void) dealloc
{
    [ID release];
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
            ID, name, email, birthdayDate, avatarURL];
}

@end
