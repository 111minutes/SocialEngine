//
//  DXSEFacebook.h
//  SocialEngine
//
//  Created by Malaar on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSEModule.h"


@interface DXSEFacebook : DXSEModule

- (void) postURL:(NSURL *)aURL andCaption:(NSString*)aCaption withSuccess:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure;

@end
