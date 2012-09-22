//
//  DXSELinkedInCompany.h
//  SocialEngine
//
//  Created by Maxim Letushov on 9/22/12.
//
//

#import <Foundation/Foundation.h>

@interface DXSELinkedInCompany : NSObject

@property (nonatomic, strong) NSNumber *companyId;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *type;

@end
