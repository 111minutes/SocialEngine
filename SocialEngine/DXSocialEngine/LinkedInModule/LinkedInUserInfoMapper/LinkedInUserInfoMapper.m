//
//  LinkedInUserInfoMapper.m
//  SocialEngine
//
//  Created by Maxim on 8/14/13.
//
//

#import "LinkedInUserInfoMapper.h"

@implementation LinkedInUserInfoMapper

+ (DXSEUserInfoLinkedIn *)userInfoFromDictionary:(NSDictionary *)userInfoDict
{
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
    
    NSDictionary *phoneNumbers = [userInfoDict objectForKey:@"phone-numbers"];
    
    
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
    
    //Phone number
    if ([phoneNumbers isKindOfClass:[NSDictionary class]]) {
        NSDictionary *phoneNumberDict = [phoneNumbers objectForKey:@"phone-number"];
        DXSELinkedInPhone *phone = [DXSELinkedInPhone new];
        phone.phoneNumber = phoneNumberDict[@"phone-number"];
        phone.phoneType = phoneNumberDict[@"phone-type"];
        
        userInfo.phone = phone;
    }
    
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

+ (DXSELinkedInPosition *)positionFromDict:(NSDictionary *)positionDict {
    
    NSString *positionId = [positionDict objectForKey:@"id"];
    NSString *title = [positionDict objectForKey:@"title"];
    NSString *isCurrent = [positionDict objectForKey:@"is-current"];
    NSDictionary *startDate = [positionDict objectForKey:@"start-date"];
    NSDictionary *endDate = [positionDict objectForKey:@"end-date"];
    NSDictionary *companyDict = [positionDict objectForKey:@"company"];
    NSString *summary = [positionDict objectForKey:@"summary"];
    
    DXSELinkedInPosition *dxsePosition = [DXSELinkedInPosition new];
    dxsePosition.positionId = positionId;
    dxsePosition.title = title;
    dxsePosition.isCurrent = isCurrent;
    dxsePosition.startDate = [self dateFromDict:startDate];
    dxsePosition.endDate = [self dateFromDict:endDate];
    dxsePosition.company = [self companyFromDict:companyDict];
    dxsePosition.summary = summary;
    
    return dxsePosition;
}

+ (DXSELinkedInEducation *)educationFromDict:(NSDictionary *)educationDict {
    
    NSString *degree = [educationDict objectForKey:@"degree"];
    NSString *fieldOfStudy = [educationDict objectForKey:@"field-of-study"];
    NSString *educationId = [educationDict objectForKey:@"id"];
    NSString *schoolName = [educationDict objectForKey:@"school-name"];
    
    NSDictionary *startDateDict = [educationDict objectForKey:@"start-date"];
    NSDictionary *endDateDict = [educationDict objectForKey:@"end-date"];
    
    NSString *notes = [educationDict objectForKey:@"notes"];
    NSString *activities = [educationDict objectForKey:@"activities"];
    
    DXSELinkedInEducation *dxseEducation = [DXSELinkedInEducation new];
    dxseEducation.degree = degree;
    dxseEducation.fieldOfStudy = fieldOfStudy;
    dxseEducation.educationId = educationId;
    dxseEducation.schoolName = schoolName;
    dxseEducation.startDate = [self dateFromDict:startDateDict];
    dxseEducation.endDate = [self dateFromDict:endDateDict];
    dxseEducation.notes = notes;
    dxseEducation.activities = activities;
    
    return dxseEducation;
}

+ (DXSELinkedInCompany *)companyFromDict:(NSDictionary *)companyDict {
    
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

+ (DXSELinkedInDate *)dateFromDict:(NSDictionary *)dateDict {
    
    NSString *year = [dateDict objectForKey:@"year"];
    NSString *month = [dateDict objectForKey:@"month"];
    
    DXSELinkedInDate *dxseDate = [DXSELinkedInDate new];
    dxseDate.year = year;
    dxseDate.month = month;
    
    return dxseDate;
}

+ (DXSELinkedInLocation *)locationFromDict:(NSDictionary *)locationDict {
    
    NSString *name = [locationDict objectForKey:@"name"];
    NSDictionary *countryDict = [locationDict objectForKey:@"country"];
    
    DXSELinkedInLocation *dxseLocation = [DXSELinkedInLocation new];
    dxseLocation.name = name;
    dxseLocation.country = [self countyFromDict:countryDict];
    
    return dxseLocation;
}

+ (DXSELinkedInCountry *)countyFromDict:(NSDictionary *)countyDict {
    
    NSString *code = [countyDict objectForKey:@"code"];
    
    DXSELinkedInCountry *dxseCountry = [DXSELinkedInCountry new];
    dxseCountry.code = code;
    
    return dxseCountry;
}


@end
