//
//  DXSEUserInfoInstagram.m
//  SocialEngine
//
//  Created by Max Mashkov on 4/13/12.
//  Copyright (c) 2012 DIMALEX. All rights reserved.
//

#import "DXSEUserInfoInstagram.h"

@implementation DXSEUserInfoInstagram


@synthesize username;
@synthesize profilePicture;
@synthesize website;
@synthesize fullName;
@synthesize bio;
@synthesize followedByCount;
@synthesize followsCount;
@synthesize mediaCount;


//==============================================================================
+ (id)userInfoInstagram 
{
    return [[DXSEUserInfoInstagram new] autorelease];
}

//==============================================================================
- (NSString *)description 
{
    return [NSString stringWithFormat:@"id=%@; name=%@; screenName=%@;", self.ID, self.fullName, self.username];
}

//==============================================================================
- (void) dealloc
{
    [username release];
    [profilePicture release];
    [website release];
    [fullName release];
    [bio release];
    [followedByCount release];
    [followsCount release];
    [mediaCount release];
    [super dealloc];
}
@end
