//
//  DXSEModule.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEInitialConfig.h"

@interface DXSEModule : NSObject
{
    DXSEInitialConfig* initialConfig;
}

@property (nonatomic, readonly) DXSEInitialConfig* initialConfig;

- (id) initWithInitialConfig:(DXSEInitialConfig*) anInitialConfig;

@end
