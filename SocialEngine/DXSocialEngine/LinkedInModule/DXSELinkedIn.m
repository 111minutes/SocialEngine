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

static NSString *cLoginKey = @"LOGIN";
static NSString *cGetProfile = @"GET_PROFILE";

@interface DXSELinkedIn () <RDLinkedInEngineDelegate, RDLinkedInAuthorizationControllerDelegate>

@property (nonatomic, strong) RDLinkedInEngine *linkedInEngine;
@property (nonatomic, strong) NSDictionary *profileFieldsDictionary;
@property (nonatomic, strong) NSMutableDictionary *requestsIdentifiersDictionary;
@end

@interface DXSELinkedIn ()
- (DXSEUserInfoLinkedIn *)userInfoFromDict:(NSDictionary *)userInfoDict;
- (DXSELinkedInDate *)dateFromDict:(NSDictionary *)dateDict;
- (DXSELinkedInCompany *)companyFromDict:(NSDictionary *)companyDict;
- (DXSELinkedInEducation *)educationFromDict:(NSDictionary *)educationDict;
- (DXSELinkedInPosition *)positionFromDict:(NSDictionary *)positionDict;
- (DXSELinkedInLocation *)locationFromDict:(NSDictionary *)locationDict;
- (DXSELinkedInCountry *)countyFromDict:(NSDictionary *)countyDict;

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
        aSuccess(self, nil);
    }
}

- (void)logout:(DXSESuccessBlock)aSuccess failure:(DXSEFailureBlock)aFailure {
    if([self isAuthorized]) {
        [self.linkedInEngine requestTokenInvalidation];
    }
    aSuccess(self, nil);
}

- (BOOL)isAuthorized {
    return self.linkedInEngine.isAuthorized;
}

- (NSString *)accessToken {
    return nil;
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
        returnResult = [self userInfoFromDict:results];
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

- (DXSEUserInfoLinkedIn *)userInfoFromDict:(NSDictionary *)userInfoDict {

    NSString *userId = [userInfoDict objectForKey:@"id"];
    NSString *firstName = [userInfoDict objectForKey:@"first-name"];
    NSString *lastName = [userInfoDict objectForKey:@"last-name"];
    NSString *email = [userInfoDict objectForKey:@"email-address"];
    NSString *headline = [userInfoDict objectForKey:@"headline"];
    NSString *industry = [userInfoDict objectForKey:@"industry"];
    NSString *summary = [userInfoDict objectForKey:@"summary"];
    NSString *numConnections = [userInfoDict objectForKey:@"num-connections"];
    NSString *lastModifiedTimestamp = [userInfoDict objectForKey:@"last-modified-timestamp"];
    NSString *pictureUrl = [userInfoDict objectForKey:@"picture-url"];
    NSString *currentShare = [userInfoDict objectForKey:@"current-share"];
    NSDictionary *educations = [userInfoDict objectForKey:@"educations"];
    NSDictionary *locationDict = [userInfoDict objectForKey:@"location"];
    NSDictionary *positions = [userInfoDict objectForKey:@"positions"];
    
    
    DXSEUserInfoLinkedIn *userInfo = [DXSEUserInfoLinkedIn new];
    
    userInfo.ID = userId;
    userInfo.firstName = firstName;
    userInfo.lastName = lastName;
    userInfo.email = email;
    userInfo.headline = headline;
    userInfo.industry = industry;
    userInfo.summary = summary;
    userInfo.numConnections = numConnections;
    userInfo.lastModifiedTimestamp = lastModifiedTimestamp;
    userInfo.pictureUrl = pictureUrl;
    userInfo.currentShare = currentShare;
    userInfo.location = [self locationFromDict:locationDict];    
    
    
    // Educations
    NSMutableArray *educationsArray = [NSMutableArray array];
    id education = [educations objectForKey:@"education"];
    if ([education isKindOfClass:[NSArray class]]) {
        for (NSDictionary *educationDict in education) {
            DXSELinkedInEducation *dxseEducation = [self educationFromDict:educationDict];
            [educationsArray addObject:dxseEducation];
        }
    }
    else if ([education isKindOfClass:[NSDictionary class]]) {
        DXSELinkedInEducation *dxseEducation = [self educationFromDict:education];
        [educationsArray addObject:dxseEducation];
    }
    userInfo.educationsArray = educationsArray;
    
    
    // Positions
    NSMutableArray *positionsArray = [NSMutableArray array];
    id position = [positions objectForKey:@"position"];
    if ([position isKindOfClass:[NSArray class]]) {
        for (NSDictionary *positionDict in position) {
            DXSELinkedInPosition *dxsePosition = [self positionFromDict:positionDict];
            [positionsArray addObject:dxsePosition];
        }
    }
    else if ([position isKindOfClass:[NSDictionary class]]) {
        DXSELinkedInPosition *dxsePosition = [self positionFromDict:position];
        [positionsArray addObject:dxsePosition];    
    }
    userInfo.positionsArray = positionsArray;
    
    return userInfo;
}

- (DXSELinkedInPosition *)positionFromDict:(NSDictionary *)positionDict {

    NSString *positionId = [positionDict objectForKey:@"id"];
    NSString *title = [positionDict objectForKey:@"title"];
    NSString *isCurrent = [positionDict objectForKey:@"is-curren"];
    NSDictionary *startDate = [positionDict objectForKey:@"start-date"];
    NSDictionary *companyDict = [positionDict objectForKey:@"company"];
    
    DXSELinkedInPosition *dxsePosition = [DXSELinkedInPosition new];
    dxsePosition.positionId = positionId;
    dxsePosition.title = title;
    dxsePosition.isCurrent = isCurrent;
    dxsePosition.startDate = [self dateFromDict:startDate];
    dxsePosition.company = [self companyFromDict:companyDict];
    
    return dxsePosition;
}

- (DXSELinkedInEducation *)educationFromDict:(NSDictionary *)educationDict {
    
    NSString *degree = [educationDict objectForKey:@"degree"];
    NSString *fieldOfStudy = [educationDict objectForKey:@"field-of-study"];
    NSString *educationId = [educationDict objectForKey:@"id"];
    NSString *schoolName = [educationDict objectForKey:@"school-name"];
    
    NSDictionary *startDateDict = [educationDict objectForKey:@"start-date"];
    NSDictionary *endDateDict = [educationDict objectForKey:@"end-date"];
    
    DXSELinkedInEducation *dxseEducation = [DXSELinkedInEducation new];
    dxseEducation.degree = degree;
    dxseEducation.fieldOfStudy = fieldOfStudy;
    dxseEducation.educationId = educationId;
    dxseEducation.schoolName = schoolName;
    dxseEducation.startDate = [self dateFromDict:startDateDict];
    dxseEducation.endDate = [self dateFromDict:endDateDict];
    
    return dxseEducation;
}

- (DXSELinkedInCompany *)companyFromDict:(NSDictionary *)companyDict {
    
    NSNumber *companyId = [companyDict objectForKey:@"id"];
    NSString *industry = [companyDict objectForKey:@"industry"];
    NSString *name = [companyDict objectForKey:@"name"];
    NSString *size = [companyDict objectForKey:@"size"];
    NSString *type = [companyDict objectForKey:@"type"];
    
    DXSELinkedInCompany *dxseCompany = [DXSELinkedInCompany new];
    dxseCompany.companyId = companyId;
    dxseCompany.industry = industry;
    dxseCompany.name = name;
    dxseCompany.size = size;
    dxseCompany.type = type;
    return dxseCompany;
}

- (DXSELinkedInDate *)dateFromDict:(NSDictionary *)dateDict {
    
    NSString *year = [dateDict objectForKey:@"year"];
    NSString *month = [dateDict objectForKey:@"month"];
    
    DXSELinkedInDate *dxseDate = [DXSELinkedInDate new];
    dxseDate.year = year;
    dxseDate.month = month;
    
    return dxseDate;
}

- (DXSELinkedInLocation *)locationFromDict:(NSDictionary *)locationDict {
    
    NSString *name = [locationDict objectForKey:@"name"];
    NSDictionary *countryDict = [locationDict objectForKey:@"country"];
    
    DXSELinkedInLocation *dxseLocation = [DXSELinkedInLocation new];
    dxseLocation.name = name;
    dxseLocation.country = [self countyFromDict:countryDict];
    
    return dxseLocation;
}

- (DXSELinkedInCountry *)countyFromDict:(NSDictionary *)countyDict {
    
    NSString *code = [countyDict objectForKey:@"code"];
    
    DXSELinkedInCountry *dxseCountry = [DXSELinkedInCountry new];
    dxseCountry.code = code;
    
    return dxseCountry;
}

- (void)setScope:(LinkedInScope)scope {
    if (scope == cLinkedInScopeDefault) {
        self.linkedInEngine.scopeRequestTokenParam = nil;
    }
    else {
        NSString *scopeString = @"";
        if ((scope & cLinkedInScopeFullProfile) != 0) {
            scopeString = @"r_fullprofile";
        }
        if (scope & cLinkedInScopeEmail) {
            scopeString = [NSString stringWithFormat:@"%@ %@", scopeString, @"r_emailaddress"];
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
