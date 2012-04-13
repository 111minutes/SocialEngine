//
//  DXSEUserInfo.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@interface DXSEUserInfoFacebook : DXSEUserInfo

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSDate *birthdayDate;
@property (nonatomic, strong) NSURL *avatarURL;

+ (id)userInfo;

@end
