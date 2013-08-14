//
//  DXSELinkedIn.h
//  SocialEngine
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import <Foundation/Foundation.h>
#import "DXSEModule.h"

static NSString *const cLoginSuccessTypeKey = @"LoginSuccessTypeKey";

extern const struct LinkedInMemberPermissions {
    __unsafe_unretained NSString *basicProfile;
    __unsafe_unretained NSString *fullProfile;
    __unsafe_unretained NSString *emailAddress;
    __unsafe_unretained NSString *contactInfo;
} LinkedInMemberPermissions;

typedef enum {
    LinkedInLoginSuccessTypeLogined,
    LinkedInLoginSuccessTypeCanceled
} LinkedInLoginSuccessType;

static NSInteger const cLinkedInScopeDefault = 0;
static NSInteger const cLinkedInScopeFullProfile = 1;
static NSInteger const cLinkedInScopeEmail = 2;
static NSInteger const cLinkedInScopeContactInfo = 4;

typedef long LINKEDIN_PROFILE_FIELDS;
typedef NSInteger LinkedInScope;

@interface DXSELinkedIn : DXSEModule

// property profileFields
//      need set before call getUserInfo
//      default value LINKEDIN_PROFILE_FIELDS__ALL
@property (nonatomic, assign) LINKEDIN_PROFILE_FIELDS profileFields;
@property (nonatomic, assign) LinkedInScope scope;

@property (nonatomic, strong, readonly) NSString *accessToken;

@end
