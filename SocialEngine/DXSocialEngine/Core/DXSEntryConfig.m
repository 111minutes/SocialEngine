//
//  DXSEInitialConfig.m
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEntryConfig.h"

@interface DXSEntryConfig ()

@property (nonatomic, readwrite, strong) NSString* oauthKey;
@property (nonatomic, readwrite, strong) NSString* oauthSecret;
@property (nonatomic, readwrite, strong) NSString* redirectURL;

@end


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
            return nil;
        }
        
        self.oauthKey = [aDictionary objectForKey:@"oauthKey"];
        self.oauthSecret = [aDictionary objectForKey:@"oauthSecret"];
        self.redirectURL = [aDictionary objectForKey:@"redirectURL"];
    }
    return self;
}

//==============================================================================
- (NSString*) description
{
    return [NSString stringWithFormat:@"oauthKey=%@; oauthSecret=%@; redirectURL=%@", oauthKey, oauthSecret, redirectURL];
}

@end
