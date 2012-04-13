//
//  DXSEUserInfoTwitter.m
//  SocialEngine
//
//  Created by Malaar on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfoTwitter.h"

@implementation DXSEUserInfoTwitter

@synthesize name, screenName;

+ (id)userInfoTwitter {
    return [[DXSEUserInfoTwitter alloc] init];
}

- (void)dealloc {
}

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@; name=%@; screenName=%@;",
            self.ID, name, screenName];
}

@end
