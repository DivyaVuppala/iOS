//
//  SalesForceOAuthLoginHelper.m
//  iPitch V2
//
//  Created by Satheeshwaran on 6/14/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "SalesForceOAuthLoginHelper.h"

#import "ZohoConstants.h"

#import "iPitchConstants.h"

#import "SFHFKeychainUtils.h"

#import "Utils.h"

typedef enum SalesForceOAuthLoginHelperWebViewStep {
	SalesForceOAuthLoginHelperWebViewStepBegin = 0,
	SalesForceOAuthLoginHelperWebViewStepPassField,
	SalesForceOAuthLoginHelperWebViewStepFormSubmitted
} SalesForceOAuthLoginHelperWebViewStep;


@interface SalesForceOAuthLoginHelper ()<UIWebViewDelegate>

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,assign) SalesForceOAuthLoginHelperWebViewStep webViewStep;

@end

#define LOGIN_CALL @"http://ipitch-test.apigee.net/oauth/authorize?response_type=code&crm=salesforce"

@implementation SalesForceOAuthLoginHelper
@synthesize webView=_webView;
@synthesize delegate;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	if (self.webView == nil)
	{
        CGRect totRect=self.view.bounds;
        totRect.origin.y=44;
		self.webView = [[UIWebView alloc] initWithFrame:totRect] ;
		[self.view addSubview:self.webView];
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [self.view addSubview:toolBar];
        
        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(cancelSalesForceLogin)];
        [toolBar setItems:[NSArray arrayWithObject:doneButton]];
        
    }
	[self performSelectorOnMainThread:@selector(loginAction) withObject:nil waitUntilDone:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self stopActivityIndicator];
}

- (void)loadView {
    
    [super loadView];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    
    // The best way to determine interface orientation is to look at status bar orientation.
    // UIDevice class measures orientation based on accelerometer and if device lays flat,
    // it won't return the correct orientation.
    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        // Change width and height if in landscapte mode
        width = self.view.frame.size.height;
        height = self.view.frame.size.width - self.navigationController.navigationBar.frame.size.height;
    }
    
    self.view.frame = CGRectMake(0, 0, width, height); //automatically resizes in case of a nav bar
    
}

- (void)startActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //[Utils showLoading:self.webView];
}

- (void)stopActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
   // [Utils removeLoading:self.webView];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)loginAction {
 
    self.webView.delegate=self;
    NSURLRequest *loginRequest=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:LOGIN_CALL]];
    [self.webView loadRequest:loginRequest];
}


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
	if (_webViewStep == SalesForceOAuthLoginHelperWebViewStepFormSubmitted) {
		// start the authentication request
		[self startActivityIndicator];
	} else if (_webViewStep == SalesForceOAuthLoginHelperWebViewStepPassField) {
        //read the document.innerHTML here and take out the JSON - hide the webview.
        NSString *jSString = [NSString stringWithFormat:@"document.body.innerHTML"];
        
        NSString *responseString= [webView stringByEvaluatingJavaScriptFromString:jSString];
        
        if ([responseString rangeOfString:AUTH_TOKEN_PARAMETER].location == NSNotFound) {
            //String not present
            [webView setHidden:NO];
        }
        
        
        else
        {
            NSError *jsonParsingError;
            
            responseString=[self stringByStrippingHTML:responseString];
            NSDictionary *authenticationResponseDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonParsingError];
            NSLog(@"authenticationResponseDict : %@", authenticationResponseDict);
            
            NSError *authError;
            
            BOOL authTokenStatus=NO;
            BOOL resfrshTokenStatus=NO;
            
            if([[authenticationResponseDict allKeys] containsObject:AUTH_TOKEN_PARAMETER])
            {
                NSString *authToken=[authenticationResponseDict objectForKey:AUTH_TOKEN_PARAMETER];
                if([SFHFKeychainUtils storeUsername:OAUTH_TOKEN andPassword:authToken forServiceName:SERVICE_NAME updateExisting:YES error:&authError])
                {
                    NSLog(@"successfully stored accesstoken in keychain at salesforce login");
                    authTokenStatus=YES;
                }
                else
                    NSLog(@"could not store accesstoken in keychain at salesforce login");

                
            }
            
            if([[authenticationResponseDict allKeys] containsObject:REFRESH_TOKEN_PARAMTER])
            {
                NSString *authRefreshToken=[authenticationResponseDict objectForKey:REFRESH_TOKEN_PARAMTER];
                if([SFHFKeychainUtils storeUsername:OAUTH_REFRESH_TOKEN andPassword:authRefreshToken forServiceName:SERVICE_NAME updateExisting:YES error:&authError])
                {
                    NSLog(@"successfully stored oauth refresh token in keychain at salesforce login");
                    resfrshTokenStatus=YES;
                }
                else
                    NSLog(@"could not store oauth refresh token in keychain at salesforce login");
                
            }
            
            [self stopActivityIndicator];

            [webView setHidden:YES];
            
            if(authTokenStatus && resfrshTokenStatus)
            {
                [self completedLoginSuccesfully];
            }
            
            else
            {
                [self loginFailedWithError];
            }
            
        }
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	// request type  UIWebViewNavigationTypeFormSubmitted means they hit log in
	// request type UIWebViewNavigationTypeOther means we fed it to the UIWebView
	if (navigationType == UIWebViewNavigationTypeOther) {
		_webViewStep = SalesForceOAuthLoginHelperWebViewStepPassField;
	} else if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
      //  NSData * httpBody = [request HTTPBody];
      //  NSString * request = [[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding] ;
        [self.webView endEditing:YES];

		_webViewStep = SalesForceOAuthLoginHelperWebViewStepFormSubmitted;
	}
	return YES;
}

- (void)completedLoginSuccesfully
{
    [self.delegate loginCompletedWithResult:SalesForceOAuthLoginResultSuccessParamter];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)loginFailedWithError
{
    [self.delegate loginCompletedWithResult:SalesForceOAuthLoginResultFailedParamter];
    [self dismissModalViewControllerAnimated:YES];

}
-(void)cancelSalesForceLogin
{
    [self.delegate loginCancelled];
    [self dismissModalViewControllerAnimated:YES];

}

-(NSString *) stringByStrippingHTML:(NSString *)inString {
    NSRange r;
    NSString *s = inString ;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
@end
