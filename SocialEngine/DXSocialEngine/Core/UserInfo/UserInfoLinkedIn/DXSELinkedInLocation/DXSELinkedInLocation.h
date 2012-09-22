//
//  DXSELinkedInLocation.h
//  SocialEngine
//
//  Created by Maxim Letushov on 9/22/12.
//
//

#import <Foundation/Foundation.h>
#import "DXSELinkedInCountry.h"

@interface DXSELinkedInLocation : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) DXSELinkedInCountry *country;

@end
