//
//  DXSELinkedIn.h
//  SocialEngine
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import <Foundation/Foundation.h>
#import "DXSEModule.h"

typedef long LINKEDIN_PROFILE_FIELDS;

static NSString *cLoginSuccessTypeKey = @"LoginSuccessTypeKey";


typedef enum {
    LinkedInLoginSuccessTypeLogined,
    LinkedInLoginSuccessTypeCanceled
} LinkedInLoginSuccessType;


@interface DXSELinkedIn : DXSEModule

// property profileFields
//      need set before call getUserInfo
//      default value LINKEDIN_PROFILE_FIELDS__ALL
@property (nonatomic, assign) LINKEDIN_PROFILE_FIELDS profileFields;

@end
