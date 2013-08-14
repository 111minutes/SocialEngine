//
//  DXSELinkedIn.m
//  SocialEngine
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import "DXSELinkedIn.h"
#import "RDLinkedIn.h"
#import "LinkedInProfileFields.h"
#import "DXSEUserInfoLinkedIn.h"
#import "LinkedInUserInfoMapper.h"

static NSString *cLoginKey = @"LOGIN";
static NSString *cGetProfile = @"GET_PROFILE";


const struct LinkedInMemberPermissions LinkedInMemberPermissions = {
    .basicProfile = @"r_basicprofile",
    .fullProfile = @"r_fullprofile",
    .emailAddress = @"r_emailaddress",
    .contactInfo = @"r_contactinfo",
};


@interface DXSELinkedIn () <RDLinkedInEngineDelegate, RDLinkedInAuthorizationControllerDelegate>

@property (nonatomic, strong) RDLinkedInEngine *linkedInEngine;
@property (nonatomic, strong) NSDictionary *profileFieldsDictionary;
@property (nonatomic, strong) NSMutableDictionary *requestsIdentifiersDictionary;
@end


@implementation DXSELinkedIn

- (id)initWithEntryConfig:(DXSEntryConfig *)anInitialConfig {
    self = [super initWithEntryConfig:anInitialConfig];
    if (self) {
        
        NSString *consumerKey = self.entryConfig.oauthKey;
        NSString *consumerSecret = self.entryConfig.oauthSecret;
        NSString *redirectURL = self.entryConfig.redirectURL;
        
        self.linkedInEngine = [RDLinkedInEngine engineWithConsumerKey:consumerKey consumerSecret:consumerSecret redirectURL:redirectURL delegate:self];

        NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__ID], @"id", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__FIRST_NAME], @"first-name", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__LAST_NAME], @"last-name", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__HEADLINE], @"headline",
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__LOCATION], @"location:(name,country:(code))",
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__INDUSTRY], @"industry", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__CURRENT_SHARE], @"current-share", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__NUM_CONNECTIONS], @"num-connections", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__SUMMARY], @"summary", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__POSITIONS], @"positions", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__PICTURE_URL], @"picture-url", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__EMAIL_ADDRESS], @"email-address", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__EDUCATIONS], @"educations", 
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__LAST_MODIFIED_TIMESTAMP], @"last-modified-timestamp",
                                [NSNumber numberWithLong:LINKEDIN_PROFILE_FIELD__PHONE], @"phone-numbers",
                                nil];
        
        self.profileFieldsDictionary = fields;
        
        self.requestsIdentifiersDictionary = [NSMutableDictionary dictionary];
        
        self.profileFields = LINKEDIN_PROFILE_FIELDS__ALL;
        
        self.scope = cLinkedInScopeDefault;
    }
    return self;
}

- (void)login:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {

    [self registerSuccessBlock:aSuccess forKey:cLoginKey];
    [self registerFailureBlock:aFailure forKey:cLoginKey];
    
    RDLinkedInAuthorizationController *controller = [RDLinkedInAuthorizationController authorizationControllerWithEngine:self.linkedInEngine delegate:self];
    if(controller) {
        [self showLoginController:controller];
    }
    else {
        NSLog(@"Already authenticated");
        if (aSuccess) {
            aSuccess(self, nil);
        }
    }
}

- (void)logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    if([self isAuthorized]) {
        [self.linkedInEngine requestTokenInvalidation];
    }
    
    if (aSuccess) {
        aSuccess(self, nil);
    }
}

- (BOOL)isAuthorized {
    return self.linkedInEngine.isAuthorized;
}

- (NSString *)accessToken {
    RD_OAToken *token = [self linkedInEngineAccessToken:self.linkedInEngine];
    return token.key;
}

- (NSString *)secretKey
{
    RD_OAToken *token = [self linkedInEngineAccessToken:self.linkedInEngine];
    return token.secret;
}

#pragma mark - UserInfo

- (void)getUserInfo:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    
    RDLinkedInConnectionID *connectionId = nil;
    
    if (self.profileFields == 0) {
        connectionId = [self.linkedInEngine profileForCurrentUser];
    }
    else {
        
        NSMutableArray *fieldsNamesArray = [NSMutableArray array];
        
        NSArray *keys =  [self.profileFieldsDictionary allKeys];
        NSArray *values = [self.profileFieldsDictionary allValues];
        
        NSInteger count = keys.count;
        for (int i = 0; i < count; i++) {
            NSNumber *value = [values objectAtIndex:i];
            if ((self.profileFields & [value longValue]) != 0) {
                [fieldsNamesArray addObject:[keys objectAtIndex:i]];
            }
        }
        
        if (fieldsNamesArray.count != 0) {
            NSString *fielsdString = @"";
            int i = 0;
            for (NSString *fielsName in fieldsNamesArray) {
                if (i != 0) {
                    fielsdString = [NSString stringWithFormat:@"%@,%@", fielsdString, fielsName];
                }
                else {
                    fielsdString = fielsName;
                }
                i++;
            }
            connectionId = [self.linkedInEngine profileForCurrentUser:fielsdString];
        }
        else {
            connectionId = [self.linkedInEngine profileForCurrentUser];
        }
    }    
    
    [self registerSuccessBlock:aSuccess forKey:connectionId];
    [self registerFailureBlock:aFailure forKey:connectionId];
    
    [self.requestsIdentifiersDictionary setValue:cGetProfile forKey:connectionId];
}


#pragma mark - RDLinkedInEngineDelegate

- (void)linkedInEngineAccessToken:(RDLinkedInEngine *)engine setAccessToken:(RD_OAToken *)token {
    if(token) {
        [token rd_storeInUserDefaultsWithServiceProviderName:@"LinkedIn" prefix:@"SocialEngine"];
    }
    else {
        [RD_OAToken rd_clearUserDefaultsUsingServiceProviderName:@"LinkedIn" prefix:@"SocialEngine"];
    }
}

- (RD_OAToken *)linkedInEngineAccessToken:(RDLinkedInEngine *)engine {
    return [RD_OAToken rd_tokenWithUserDefaultsUsingServiceProviderName:@"LinkedIn" prefix:@"SocialEngine"];
}

- (void)linkedInEngine:(RDLinkedInEngine *)engine requestSucceeded:(RDLinkedInConnectionID *)identifier withResults:(id)results {
    
    id returnResult = results;
    
    NSString *requestIdentifier = [self.requestsIdentifiersDictionary objectForKey:identifier];
    if ([requestIdentifier isEqualToString:cGetProfile]) {
        returnResult = [LinkedInUserInfoMapper userInfoFromDictionary:results];
    }
    
    [self.requestsIdentifiersDictionary removeObjectForKey:identifier];
    [self executeSuccessBlockForKey:identifier withData:returnResult];
}

- (void)linkedInEngine:(RDLinkedInEngine *)engine requestFailed:(RDLinkedInConnectionID *)identifier withError:(NSError *)error {
    
    [self.requestsIdentifiersDictionary removeObjectForKey:identifier];    
    [self executeFailureBlockForKey:identifier withError:error];
}


#pragma mark - RDLinkedInAuthorizationControllerDelegate

- (void)linkedInAuthorizationControllerSucceeded:(RDLinkedInAuthorizationController *)controller {
    NSDictionary *resultDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:LinkedInLoginSuccessTypeLogined] forKey:cLoginSuccessTypeKey];
    [self executeSuccessBlockForKey:cLoginKey withData:resultDictionary];
    [self hideLoginController];
}

- (void)linkedInAuthorizationControllerFailed:(RDLinkedInAuthorizationController *)controller {
    [self executeFailureBlockForKey:cLoginKey withError:nil];
    [self hideLoginController];
}

- (void)linkedInAuthorizationControllerCanceled:(RDLinkedInAuthorizationController *)controller {
    NSDictionary *resultDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:LinkedInLoginSuccessTypeCanceled] forKey:cLoginSuccessTypeKey];
    [self executeSuccessBlockForKey:cLoginKey withData:resultDictionary];
    [self hideLoginController];
}

#pragma mark - Responces Parsing

- (void)setScope:(LinkedInScope)scope {
    if (scope == cLinkedInScopeDefault) {
        self.linkedInEngine.scopeRequestTokenParam = nil;
    }
    else {
        NSString *scopeString = @"";
        if ((scope & cLinkedInScopeFullProfile) != 0) {
            scopeString = LinkedInMemberPermissions.fullProfile;
        }
        if (scope & cLinkedInScopeEmail) {
            scopeString = [NSString stringWithFormat:@"%@ %@", scopeString, LinkedInMemberPermissions.emailAddress];
        }
        if (scope & cLinkedInScopeContactInfo) {
            scopeString = [NSString stringWithFormat:@"%@ %@", scopeString, LinkedInMemberPermissions.contactInfo];
        }
        
        if (scopeString.length != 0) {
            self.linkedInEngine.scopeRequestTokenParam = scopeString;
        }
        else {
            self.linkedInEngine.scopeRequestTokenParam = nil;
        }
    }
}


@end
