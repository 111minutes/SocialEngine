//
//  DXSEUserInfo.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXSEUserInfo : NSObject

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSDate *birthdayDate;
@property (nonatomic, retain) NSURL *avatarURL;

+ (id) userInfo;

@end
