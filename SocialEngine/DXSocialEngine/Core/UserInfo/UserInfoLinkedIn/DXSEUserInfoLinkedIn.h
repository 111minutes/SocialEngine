//
//  DXSEUserInfoLinkedIn.h
//  SocialEngine
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import "DXSEUserInfo.h"
#import "DXSELinkedInPosition.h"
#import "DXSELinkedInEducation.h"
#import "DXSELinkedInLocation.h"

@interface DXSEUserInfoLinkedIn : DXSEUserInfo

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) NSString *numConnections;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *pictureUrl;
@property (nonatomic, strong) NSString *currentShare;   //like status
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *lastModifiedTimestamp;
@property (nonatomic, strong) NSArray *positionsArray;
@property (nonatomic, strong) NSArray *educationsArray;
@property (nonatomic, strong) DXSELinkedInLocation *location;

@end
