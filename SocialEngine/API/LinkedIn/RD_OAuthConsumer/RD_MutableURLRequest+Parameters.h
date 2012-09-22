//
//  RD_MutableURLRequest+Parameters.h
//  OAuthConsumer-iPhoneLib
//
//  Created by Maxim Letushov on 9/21/12.
//
//

#import "RD_MutableURLRequest.h"
#import "RD_OARequestParameter.h"
#import "NSURL+Base.h"

@interface RD_MutableURLRequest (Parameters)

- (NSArray *)parameters;
- (void)setParameters:(NSArray *)parameters;

@end
