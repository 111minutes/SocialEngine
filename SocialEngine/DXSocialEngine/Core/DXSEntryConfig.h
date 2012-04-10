//
//  DXSEInitialConfig.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXSEntryConfig : NSObject

@property (nonatomic, readonly, strong) NSString* oauthKey;
@property (nonatomic, readonly, strong) NSString* oauthSecret;
@property (nonatomic, readonly, strong) NSString* redirectURL;

- (id) initWithDictionary:(NSDictionary*)aDictionary;

@end
