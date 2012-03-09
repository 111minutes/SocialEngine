//
//  DXSEUserInfoTwitter.h
//  SocialEngine
//
//  Created by Malaar on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXSEUserInfo.h"

@interface DXSEUserInfoTwitter : DXSEUserInfo

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* screenName;

+ (id) userInfoTwitter;

@end
