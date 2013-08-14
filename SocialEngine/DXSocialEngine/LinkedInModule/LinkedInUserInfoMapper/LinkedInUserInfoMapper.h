//
//  LinkedInUserInfoMapper.h
//  SocialEngine
//
//  Created by Maxim on 8/14/13.
//
//

#import <Foundation/Foundation.h>
#import "DXSEUserInfoLinkedIn.h"

@interface LinkedInUserInfoMapper : NSObject

+ (DXSEUserInfoLinkedIn *)userInfoFromDictionary:(NSDictionary *)userInfoDict;

@end
