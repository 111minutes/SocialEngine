//
//  DXViewController.m
//  SocialEngine
//
//  Created by Malaar on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXViewController.h"
#import "DXSESocialEngine.h"
#import "LinkedInProfileFields.h"
#import "DXSEUserInfoLinkedIn.h"

@implementation DXViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Button Action
- (IBAction)twitterLoginPressed:(id)sender {
    [[DXSESocialEngine sharedInstance].twitter login:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"logged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

         [[DXSESocialEngine sharedInstance].twitter getUserInfo:^(DXSEModule * module, id data)
          {
              NSLog (@"UserInfo(Twitter): %@", [data description]);
          } failure:^(DXSEModule * module, NSError * error)
          {
              NSLog (@"UserInfo: failed");
          }];
     } failure:^(DXSEModule * module, NSError * error)
     {
         [[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }];
}

- (IBAction)facebookLoginPressed:(id)sender {
    [[DXSESocialEngine sharedInstance].facebook login:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"loged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         NSLog (@"facebook accessToken %@", [[DXSESocialEngine sharedInstance].facebook accessToken]);
         [[DXSESocialEngine sharedInstance].facebook getUserInfo:^(DXSEModule * module, id data)
          {
              NSLog (@"facebook accessToken %@", [[DXSESocialEngine sharedInstance].facebook accessToken]);
              NSLog (@"UserInfo(Facebook): %@", [data description]);
          } failure:^(DXSEModule * module, NSError * error)
          {
              NSLog (@"UserInfo: failed");
          }];
     } failure:^(DXSEModule * module, NSError * error)
     {
         [[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }];
}

- (IBAction)foursquareLoginPressed:(id)sender {
    [[DXSESocialEngine sharedInstance].fourSquare login:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"4Square" message:@"loged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

         [[DXSESocialEngine sharedInstance].fourSquare getUserInfo:^(DXSEModule * module, id data)
          {
              NSLog (@"UserInfo(FourSquare): %@", data);
          } failure:^(DXSEModule * module, NSError * error)
          {
              NSLog (@"UserInfo: failed");
          }];
     } failure:^(DXSEModule * module, NSError * error)
     {
         [[[UIAlertView alloc] initWithTitle:@"4Square" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }];
}


- (IBAction)instagramLoginPressed:(id)sender {
    [[DXSESocialEngine sharedInstance].instagram login:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"Instagram" message:@"logged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

         [[DXSESocialEngine sharedInstance].instagram getUserInfo:^(DXSEModule * module, id data)
          {
              NSLog (@"UserInfo(Instagram): %@", data);
          } failure:^(DXSEModule * module, NSError * error)
          {
              NSLog (@"UserInfo: failed");
          }];
     } failure:^(DXSEModule * module, NSError * error)
     {
         [[[UIAlertView alloc] initWithTitle:@"Instagram" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }];
}

- (IBAction)linkedInLoginPressed:(id)sender {
    [[DXSESocialEngine sharedInstance].linkedIn setScope:cLinkedInScopeFullProfile | cLinkedInScopeEmail];
    [[DXSESocialEngine sharedInstance].linkedIn login:^(DXSEModule *module, NSDictionary *result) {
        
        LinkedInLoginSuccessType successType = [[result valueForKey:cLoginSuccessTypeKey] integerValue];
        
        if (successType == LinkedInLoginSuccessTypeLogined) {
            [[[UIAlertView alloc] initWithTitle:@"LinkedIn" message:@"logged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            [[DXSESocialEngine sharedInstance].linkedIn setProfileFields:LINKEDIN_PROFILE_FIELDS__ALL];
            
            [[DXSESocialEngine sharedInstance].linkedIn getUserInfo:^(DXSEModule * module, DXSEUserInfoLinkedIn *data) {
                NSLog(@"%@", data);
                
            } failure:^(DXSEModule * module, NSError * error) {
                NSLog (@"UserInfo: failed");
            }];
        }
        else if (successType == LinkedInLoginSuccessTypeCanceled){
            [[[UIAlertView alloc] initWithTitle:@"LinkedIn" message:@"Login Canceled !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];        
        }
        
    } failure:^(DXSEModule *module, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"LinkedIn" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}


- (IBAction)facebookLogout {
    [[DXSESocialEngine sharedInstance].facebook logout:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"loged out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     } failure:^(DXSEModule * module, NSError * error)
     {
         [[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"logout error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }];
}

- (IBAction)twitterLogout {
    [[DXSESocialEngine sharedInstance].twitter logout:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"loged out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     } failure:nil];
}

- (IBAction)foursquareLogout
{
    [[DXSESocialEngine sharedInstance].fourSquare logout:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"FourSquare" message:@"loged out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     } failure:nil];
}

- (IBAction)instagramLogout
{
    [[DXSESocialEngine sharedInstance].instagram logout:^(DXSEModule * module, id data)
     {
         [[[UIAlertView alloc] initWithTitle:@"Instagram" message:@"loged out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     } failure:nil];
}

- (IBAction)linkedInLogout {
    [[DXSESocialEngine sharedInstance].linkedIn logout:^(DXSEModule *module, id data) {
        [[[UIAlertView alloc] initWithTitle:@"LinkedIn" message:@"loged out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];        
    } failure:^(DXSEModule *module, NSError *error) {
        
    }];
}


@end
