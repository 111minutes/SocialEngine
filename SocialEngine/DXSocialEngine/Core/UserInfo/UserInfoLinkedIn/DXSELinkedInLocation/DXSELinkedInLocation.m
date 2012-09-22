//
//  DXSELinkedInLocation.m
//  SocialEngine
//
//  Created by Maxim Letushov on 9/22/12.
//
//

#import "DXSELinkedInLocation.h"

@implementation DXSELinkedInLocation

- (id)init {
    self = [super init];
    if (self) {
        self.country = [DXSELinkedInCountry new];
    }
    return self;
}

@end
