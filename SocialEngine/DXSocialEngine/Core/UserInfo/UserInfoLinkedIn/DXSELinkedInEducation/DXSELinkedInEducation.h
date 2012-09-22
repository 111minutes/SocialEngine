//
//  DXSELinkedInEducation.h
//  SocialEngine
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import <Foundation/Foundation.h>
#import "DXSELinkedInDate.h"

@interface DXSELinkedInEducation : NSObject

@property (nonatomic, strong) NSString *educationId;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *fieldOfStudy;
@property (nonatomic, strong) NSString *degree;
@property (nonatomic, strong) DXSELinkedInDate *startDate;
@property (nonatomic, strong) DXSELinkedInDate *endDate;

@end
