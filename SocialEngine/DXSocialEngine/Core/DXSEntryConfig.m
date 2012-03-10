//
//  DXSEInitialConfig.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEntryConfig.h"

@implementation DXSEntryConfig

@synthesize oauthKey;
@synthesize oauthSecret;
@synthesize redirectURL;

//==============================================================================
- (id) initWithDictionary:(NSDictionary*)aDictionary
{
    if( (self = [super init]) )
    {
        if(!aDictionary)
        {
            [self release];
            return nil;
        }
        
        oauthKey = [[aDictionary objectForKey:@"oauthKey"] retain];
        oauthSecret = [[aDictionary objectForKey:@"oauthSecret"] retain];
        redirectURL = [[aDictionary objectForKey:@"redirectURL"] retain];
    }
    return self;
}

//==============================================================================
- (NSString*) description
{
    return [NSString stringWithFormat:@"oauthKey=%@; oauthSecret=%@; redirectURL=%@", oauthKey, oauthSecret, redirectURL];
}

@end
