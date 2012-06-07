//
//  DXSEUserInfoTwitter.h
//  SocialEngine
//
//  Created by Malaar on 09.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXSEUserInfoTwitter : NSObject

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* screenName;
@property (nonatomic, retain) NSURL*    avatarURL;

+ (id) userInfoTwitter;

@end
