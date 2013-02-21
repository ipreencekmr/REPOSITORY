//
//  FBCustomLoginDialog.m
//  LikeApp
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2013 MaxMobility Pvt. Ltd. All rights reserved.
//

#import "FBCustomLoginDialog.h"

@implementation FBCustomLoginDialog

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL* url = request.URL;
	if ([[url absoluteString] rangeOfString:@"login"].location == NSNotFound) {
		[self dialogDidSucceed:url];
		return NO;
	}
	else if (url != nil) {
		[_spinner startAnimating];
		[_spinner setHidden:NO];
		return YES;
	}
	return NO;
}
@end
