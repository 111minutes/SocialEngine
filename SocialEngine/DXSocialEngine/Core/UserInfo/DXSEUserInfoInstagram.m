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
@synthesize instagramId;
@synthesize profilePicture;
@synthesize website;
@synthesize fullName;
@synthesize bio;
@synthesize followedByCount;
@synthesize followsCount;
@synthesize mediaCount;


+ (id)userInfoInstagram {
    return [DXSEUserInfoInstagram new];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@; name=%@; screenName=%@;", self.instagramId, self.fullName, self.username];
}

@end
