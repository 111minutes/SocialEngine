//
//  DXSEUserInfoInstagram.h
//  SocialEngine
//
//  Created by Max Mashkov on 4/13/12.
//  Copyright (c) 2012 DIMALEX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEUserInfo.h"

@interface DXSEUserInfoInstagram : DXSEUserInfo

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *instagramId;
@property (strong, nonatomic) NSString *profilePicture;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSNumber *followedByCount;
@property (strong, nonatomic) NSNumber *followsCount;
@property (strong, nonatomic) NSNumber *mediaCount;

+ (id) userInfoInstagram;

@end
