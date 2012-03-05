//
//  DXSEInitialConfig.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXSEntryConfig : NSObject

@property (nonatomic, readonly) NSString* oauthKey;
@property (nonatomic, readonly) NSString* oauthSecret;
@property (nonatomic, readonly) NSString* redirectURL;

- (id) initWithDictionary:(NSDictionary*)aDictionary;

@end
