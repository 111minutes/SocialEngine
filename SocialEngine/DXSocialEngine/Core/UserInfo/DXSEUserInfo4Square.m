//
//  DXSEUserInfo4Square.m
//  SocialEngine
//
//  Created by Malaar on 10.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo4Square.h"

@implementation DXSEUserInfo4Square

@synthesize firstName, lastName, email, avatarURL;

//==============================================================================
+ (id) userInfo4Square
{
    return [[[DXSEUserInfo4Square alloc] init] autorelease];
}

//==============================================================================
- (void) dealloc
{
    [firstName release];
    [lastName release];
    [email release];
    [avatarURL release];
    
    [super dealloc];
}

//==============================================================================
- (NSString*) description
{
    return [NSString stringWithFormat:@"id=%@; firstName=%@; lastName=%@; email=%@; avatarURL=%@;",
            self.ID, firstName, lastName, email, avatarURL];
}

@end
