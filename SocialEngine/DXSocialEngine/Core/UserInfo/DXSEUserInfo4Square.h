//
//  DXSEUserInfo4Square.h
//  SocialEngine
//
//  Created by Malaar on 10.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXSEUserInfo4Square : NSObject

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSURL *avatarURL;

+ (id) userInfo4Square;

@end
