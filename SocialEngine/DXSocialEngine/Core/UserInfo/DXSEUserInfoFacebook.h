//
//  DXSEUserInfo.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@interface DXSEUserInfoFacebook : DXSEUserInfo

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSDate *birthdayDate;
@property (nonatomic, retain) NSURL *avatarURL;

+ (id) userInfo;

@end
