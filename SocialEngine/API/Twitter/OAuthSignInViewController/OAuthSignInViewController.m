    //
//  OAuthSignInViewController.m
//  TwitterCommonLibrary
//
//  Created by Tim Shi on 11-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OAuthSignInViewController.h"

// iPhone frames
#define IPHONE_VIEW_FRAME CGRectMake(0, 0, 320, 416)
#define IPHONE_BACKGROUND_VIEW_FRAME CGRectMake(0, 44, 320, 416)
#define IPHONE_NAVIGATION_BAR_FRAME CGRectMake(0, 0, 320, 44)

// iPad frames
#define IPAD_VIEW_FRAME CGRectMake(0, 0, 768, 960)
#define IPAD_BACKGROUND_VIEW_FRAME CGRectMake(0, 44, 768, 960)
#define IPAD_NAVIGATION_BAR_FRAME CGRectMake(0, 0, 768, 44)

BOOL isIPad(void);

@implementation OAuthSignInViewController
@synthesize delegate;

BOOL isIPad()
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (id)init
{
    return [self initWithDelegate:NULL];
}

- (id)initWithDelegate:(id<OAuthSignInViewControllerDelegate>) aDelegate{
	if (self = [super init]) {		
		self.delegate = aDelegate;
		_firstLoad = YES;		
		
        _webView = [[UIWebView alloc] initWithFrame: isIPad() ? IPAD_BACKGROUND_VIEW_FRAME : IPHONE_BACKGROUND_VIEW_FRAME];		
        _webView.alpha = 0.0;
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //Because twitter will present a pin on the site instead of the oauth_verifier for mobile applications
        //we will try to detect the number, so we turn off phone number recognition and we turn on data recognition.
        if ([_webView respondsToSelector: @selector(setDetectsPhoneNumbers:)]){ 			
            [(id) _webView setDetectsPhoneNumbers: NO];
        }
        if ([_webView respondsToSelector: @selector(setDataDetectorTypes:)]){
            [(id) _webView setDataDetectorTypes:UIDataDetectorTypeNone];
        }
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
    //    NSBundle* twitterBundle = [NSBundle bundleWithPath:@"Twitter.bundle"];
    //    NSString* bgImagePath = [twitterBundle pathForResource:@"twitter_load" ofType:@"png" inDirectory:@"images"];
    
    NSString* bgImagePath = @"Twitter.bundle/images/twitter_load.png";
	_backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:bgImagePath]] autorelease];
    
//	self.view = [[[UIView alloc] initWithFrame: isIPad() ? IPAD_VIEW_FRAME : IPHONE_VIEW_FRAME ] autorelease];	
	_backgroundView.frame =  isIPad() ? IPAD_BACKGROUND_VIEW_FRAME : IPHONE_BACKGROUND_VIEW_FRAME;
	_navBar = [[[UINavigationBar alloc] initWithFrame: isIPad() ? IPAD_NAVIGATION_BAR_FRAME : IPHONE_NAVIGATION_BAR_FRAME] autorelease];
    
	_navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:_backgroundView];
	
    [self.view addSubview: _webView];
	
	[self.view addSubview: _navBar];
	
	_blockerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 60)] autorelease];
	_blockerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
	_blockerView.alpha = 0.0;
	_blockerView.clipsToBounds = YES;
    
	UILabel	*label = [[[UILabel alloc] initWithFrame: CGRectMake(0, 5, _blockerView.bounds.size.width, 15)] autorelease];
	label.text = NSLocalizedString(@"Please Wait…", nil);
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize: 15];
	[_blockerView addSubview: label];
	
	UIActivityIndicatorView	*spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];	
	spinner.center = CGPointMake(_blockerView.bounds.size.width / 2, _blockerView.bounds.size.height / 2 + 10);
	[_blockerView addSubview: spinner];
	[self.view addSubview: _blockerView];
	[spinner startAnimating];
	
	UINavigationItem *navItem = [[[UINavigationItem alloc] initWithTitle: NSLocalizedString(@"Twitter Sign In", nil)] autorelease];
	navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target:self action: @selector(cancel:)] autorelease];
	
	[_navBar pushNavigationItem: navItem animated: NO];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark SignUp call backs
- (void) denied {
	[_delegate authenticationFailed];
}

- (void) gotPin: (NSString *) pin {
#ifdef DEBUG
	NSLog(@"got pin %@", pin);
#endif
	[self.delegate authenticatedWithPin:pin];
}

- (void) cancel:(id) sender {
	[self.delegate authenticationCanceled];
}
#pragma mark SignUp call back end

#pragma mark webViewDelegate
- (void) webViewDidStartLoad: (UIWebView *) webView {
	_loading = YES;
	[UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 1.0;
	[UIView commitAnimations];
}


- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType {
	NSData				*data = [request HTTPBody];
	char				*raw = data ? (char *) [data bytes] : "";
	
	if (raw && strstr(raw, "cancel=")) {
		[self denied];
		return NO;
	}
    else if (raw && strstr(raw, "_method=delete"))
    {
        _firstLoad = YES;
    }
	if (navigationType != UIWebViewNavigationTypeOther) _webView.alpha = 0.1;
	return YES;
}

- (void) webViewDidFinishLoad: (UIWebView *) webView {
    _loading = NO;
    //[self performInjection];
    if (_firstLoad) {
        [_webView performSelector: @selector(stringByEvaluatingJavaScriptFromString:) withObject: @"window.scrollBy(0,200)" afterDelay: 0];
        _firstLoad = NO;
    } else {
        //*****************************************************
        //  This is to bypass the pin requirement
        //  in case the call back URL is set in Twitter settings
        //*****************************************************
        [self.delegate authenticated];
        return;
    }
    
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
    
    if ([_webView isLoading]) {
        _webView.alpha = 0.0;
    } else {
        _webView.alpha = 1.0;
    }
}

#pragma mark webViewDelegate end


#pragma mark utility for finding the pin
- (NSString *) locateAuthPinInWebView: (UIWebView *) webView {
	NSString			*js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); if (d) d = d.innerHTML; if (d == null) {var r = new RegExp('\\\\s[0-9]+\\\\s'); d = r.exec(document.body.innerHTML); if (d.length > 0) d = d[0];} d.replace(/^\\s*/, '').replace(/\\s*$/, ''); d;";
	NSString			*pin = [webView stringByEvaluatingJavaScriptFromString: js];	
	NSString			*html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
	
	if (html.length == 0){
		return nil;
	}
	
	const char *rawHTML = (const char *) [html UTF8String];
	int	length = strlen(rawHTML), chunkLength = 0;
	
	for (int i = 0; i < length; i++) {
		if (rawHTML[i] < '0' || rawHTML[i] > '9') {
			if (chunkLength == 7) {
				char *buffer = (char *) malloc(chunkLength + 1);

				memmove(buffer, &rawHTML[i - chunkLength], chunkLength);
				buffer[chunkLength] = 0;
				
				pin = [NSString stringWithUTF8String: buffer];
				free(buffer);
				return pin;
			}
			chunkLength = 0;
		} else
			chunkLength++;
	}	
	return nil;
}


#pragma mark utility for finding the pin end

- (void) loadRequest:(NSURLRequest*) request{
	[_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[_webView release];
    // Malaar: fuck my mind!
//	[_navBar release];
//	[_backgroundView release];	
//	[_blockerView release];	
    [super dealloc];
}


@end
