//
//  DXSELinkedInPosition.h
//  SocialEngine
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import <Foundation/Foundation.h>
#import "DXSELinkedInCompany.h"
#import "DXSELinkedInDate.h"

@interface DXSELinkedInPosition : NSObject

@property (nonatomic, strong) NSString *positionId;
@property (nonatomic, strong) NSString *isCurrent;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) DXSELinkedInDate *startDate;
@property (nonatomic, strong) DXSELinkedInCompany *company;

@end
