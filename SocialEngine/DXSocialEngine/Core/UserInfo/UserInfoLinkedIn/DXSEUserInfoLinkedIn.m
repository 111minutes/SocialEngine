//
//  DXSEUserInfoLinkedIn.m
//  SocialEngine
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import "DXSEUserInfoLinkedIn.h"

@implementation DXSEUserInfoLinkedIn

- (id)init {
    self = [super init];
    if (self) {
        self.location = [DXSELinkedInLocation new];
        self.positionsArray = [NSArray array];
        self.educationsArray = [NSArray array];
    }
    return self;
}

@end
