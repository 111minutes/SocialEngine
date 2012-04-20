//
//  DXViewController.h
//  SocialEngine
//
//  Created by Malaar on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXViewController : UIViewController

- (IBAction)twitterLoginPressed:(id)sender;
- (IBAction)facebookLoginPressed:(id)sender;
- (IBAction)foursquareLoginPressed:(id)sender;
- (IBAction)instagramLoginPressed:(id)sender;

- (IBAction)facebookLogout;
- (IBAction)twitterLogout;
- (IBAction)foursquareLogout;
- (IBAction)instagramLogout;

@end
