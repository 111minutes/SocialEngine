//
//  DXSEUserInfo4Square.h
//  SocialEngine
//
//  Created by Malaar on 10.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@interface DXSEUserInfo4Square : DXSEUserInfo

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSURL *avatarURL;

+ (id) userInfo4Square;

@end
