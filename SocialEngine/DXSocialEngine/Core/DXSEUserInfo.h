//
//  DXSEUserInfo.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXSEUserInfo : NSObject

@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic, retain) NSDate *userBirthdayDate;
@property (nonatomic, retain) NSString *userAvatarURL;

@end
