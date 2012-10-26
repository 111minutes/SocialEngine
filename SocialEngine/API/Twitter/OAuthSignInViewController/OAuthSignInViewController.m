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
#define IPAD_VIEW_FRAME UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? CGRectMake(0, 0, 768, 960) : CGRectMake(0, 0, 1024, 704)
#define IPAD_BACKGROUND_VIEW_FRAME UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? CGRectMake(0, 44, 768, 960) : CGRectMake(0, 44, 1024, 704)
#define IPAD_NAVIGATION_BAR_FRAME UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? CGRectMake(0, 0, 768, 44) : CGRectMake(0, 0, 1024, 44)

BOOL isPad(void);

BOOL isPad()
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@implementation OAuthSignInViewController

@synthesize delegate;


- (id)init {
    return [self initWithDelegate:NULL];
}

- (id)initWithDelegate:(id<OAuthSignInViewControllerDelegate>)aDelegate {
    
	if (self = [super init]) {
		self.delegate = aDelegate;
		_firstLoad = YES;
		
        _webView = [[UIWebView alloc] initWithFrame: isPad() ? IPAD_BACKGROUND_VIEW_FRAME : IPHONE_BACKGROUND_VIEW_FRAME];
        _webView.alpha = 0.0;
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //Because twitter will present a pin on the site instead of the oauth_verifier for mobile applications
        //we will try to detect the number, so we turn off phone number recognition and we turn on data recognition.
        if ([_webView respondsToSelector:@selector(setDetectsPhoneNumbers:)]){
            [(id)_webView setDetectsPhoneNumbers: NO];
        }
        if ([_webView respondsToSelector:@selector(setDataDetectorTypes:)]){
            [(id)_webView setDataDetectorTypes:UIDataDetectorTypeNone];
        }
	}
	return self;
}

- (void)dealloc {
	[_webView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
	[super viewDidLoad];
    //    NSBundle *twitterBundle = [NSBundle bundleWithPath:@"Twitter.bundle"];
    //    NSString *bgImagePath = [twitterBundle pathForResource:@"twitter_load" ofType:@"png" inDirectory:@"images"];
    
    self.view.frame =  isPad() ? IPAD_VIEW_FRAME : IPHONE_VIEW_FRAME;
    
    _backgroundView = [[[UIImageView alloc] initWithFrame:isPad() ? IPAD_BACKGROUND_VIEW_FRAME : IPHONE_BACKGROUND_VIEW_FRAME] autorelease];
	_backgroundView.contentMode = UIViewContentModeScaleToFill;
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    UIImage *backGroundImage = [UIImage imageNamed:@"Twitter.bundle/images/twitter_load.png"];
    if (!backGroundImage) {
        _backgroundView.image = backGroundImage;
    }
    
	_navBar = [[[UINavigationBar alloc] initWithFrame: isPad() ? IPAD_NAVIGATION_BAR_FRAME : IPHONE_NAVIGATION_BAR_FRAME] autorelease];
	_navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_backgroundView];
    [self.view addSubview:_webView];
	[self.view addSubview:_navBar];
	
	_blockerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)] autorelease];
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    CGRect frame = _blockerView.frame;
    frame.origin = CGPointMake(ceilf(frame.origin.x), ceilf(frame.origin.y));
    _blockerView.frame = frame;
	_blockerView.alpha = 0.0;
	_blockerView.clipsToBounds = YES;
    
	UILabel	*label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 5, _blockerView.bounds.size.width, 15)] autorelease];
	label.text = NSLocalizedString(@"Please Wait...", nil);
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize:15];
	[_blockerView addSubview:label];
	
	UIActivityIndicatorView	*spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
	spinner.center = CGPointMake(_blockerView.bounds.size.width / 2, _blockerView.bounds.size.height / 2 + 10);
	[_blockerView addSubview:spinner];
	[self.view addSubview:_blockerView];
	[spinner startAnimating];
	
	UINavigationItem *navItem = [[[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Twitter Sign In", nil)] autorelease];
	navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancel:)]
                                 autorelease];
	
	[_navBar pushNavigationItem:navItem animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == [[UIApplication sharedApplication] statusBarOrientation];
}

#pragma mark - SignUp call backs
- (void) denied {
	[_delegate authenticationFailed];
}

- (void) gotPin: (NSString *) pin {
#ifdef DEBUG
	NSLog(@"got pin %@", pin);
#endif
	[self.delegate authenticatedWithPin:pin];
}

- (void)cancel:(id)sender {
	[self.delegate authenticationCanceled];
}

#pragma mark -
#pragma mark - SignUp call back end

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
	_loading = NO;
	if (_firstLoad) {
		_firstLoad = NO;
	}else {
		//This is when the screen refreshed because user has authenticated.
		NSString *authPin = [self locateAuthPinInWebView: webView];
		
		if (authPin.length) {
			[self gotPin: authPin];
			return;
		}
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

- (void) webViewDidStartLoad: (UIWebView *) webView {
	_loading = YES;
	[UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 1.0;
	[UIView commitAnimations];
}


- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
	NSData	*data = [request HTTPBody];
	char *raw = data ? (char *) [data bytes] : "";
	
	//User canceled from within the web view
	if (raw && strstr(raw, "cancel=")) {
		[self denied];
		return NO;
	}
	if (navigationType != UIWebViewNavigationTypeOther) _webView.alpha = 0.1;
	return YES;
}

#pragma mark - utility for finding the pin

- (NSString *)locateAuthPinInWebView:(UIWebView *)webView {
    
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

#pragma mark - Utility for finding the pin end

- (void) loadRequest:(NSURLRequest*) request{
	[_webView loadRequest:request];
}

@end
