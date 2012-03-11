//
//  DXViewController.m
//  SocialEngine
//
//  Created by Malaar on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DXViewController.h"
#import "DXSESocialEngine.h"

@implementation DXViewController

#pragma mark - View lifecycle
//==============================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
}

//==============================================================================
- (void)viewDidUnload
{
    [super viewDidUnload];
}

//==============================================================================
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//==============================================================================
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Button Action
//==============================================================================
- (IBAction)twitterLoginPressed:(id)sender
{
    [[DXSESocialEngine sharedInstance].twitter login:^(DXSEModule *module, id data)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"loged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        
        [[DXSESocialEngine sharedInstance].twitter getUserInfo:^(DXSEModule *module, id data)
        {
            NSLog(@"UserInfo(Twitter): %@", [data description]);
            
        } failure:^(DXSEModule *module, NSError *error)
        {
            NSLog(@"UserInfo: failed");
        }];
        
    } failure:^(DXSEModule *module, NSError *error)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
}

//==============================================================================
- (IBAction)facebookLoginPressed:(id)sender
{
    [[DXSESocialEngine sharedInstance].facebook login:^(DXSEModule *module, id data)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"loged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        
        [[DXSESocialEngine sharedInstance].facebook getUserInfo:^(DXSEModule *module, id data)
        {
            NSLog(@"UserInfo(Facebook): %@", [data description]);
            
        } failure:^(DXSEModule *module, NSError *error)
        {
            NSLog(@"UserInfo: failed");
        }];
    
    } failure:^(DXSEModule *module, NSError *error)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
}

//==============================================================================
- (IBAction)foursquareLoginPressed:(id)sender
{
    [[DXSESocialEngine sharedInstance].fourSquare login:^(DXSEModule *module, id data)
    {
        [[[[UIAlertView alloc] initWithTitle:@"4Square" message:@"loged in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        
        [[DXSESocialEngine sharedInstance].fourSquare getUserInfo:^(DXSEModule *module, id data)
        {
            NSLog(@"UserInfo(FourSquare): %@", data);
            
        } failure:^(DXSEModule *module, NSError *error)
        {
            NSLog(@"UserInfo: failed");
        }];

    } failure:^(DXSEModule *module, NSError *error)
    {
        [[[[UIAlertView alloc] initWithTitle:@"4Square" message:@"login error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
}

//==============================================================================
- (IBAction)facebookLogout
{
    [[DXSESocialEngine sharedInstance].facebook logout:^(DXSEModule *module, id data)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"loged out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];

    } failure:^(DXSEModule *module, NSError *error)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Facebook" message:@"logout error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }];
}

//==============================================================================
- (IBAction)twitterLogout
{
    [[DXSESocialEngine sharedInstance].twitter logout:^(DXSEModule *module, id data)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Twitter" message:@"loged out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        
    } failure:nil];
}

@end
