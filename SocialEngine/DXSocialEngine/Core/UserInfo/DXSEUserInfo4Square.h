//
//  DXSEUserInfo4Square.h
//  SocialEngine
//
//  Created by Malaar on 10.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@interface DXSEUserInfo4Square : DXSEUserInfo

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSURL *avatarURL;

+ (id) userInfo4Square;

@end
