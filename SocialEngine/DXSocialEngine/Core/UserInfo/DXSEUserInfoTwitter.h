//
//  DXSEUserInfoTwitter.h
//  SocialEngine
//
//  Created by Malaar on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@interface DXSEUserInfoTwitter : DXSEUserInfo

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* screenName;

+ (id) userInfoTwitter;

@end
