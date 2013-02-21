//
//  FBLikeButton.m
//  LikeApp
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2013 MaxMobility Pvt. Ltd. All rights reserved.
//

#import "FBLikeButton.h"

//LoginDialog es estatica para abrir unicamente un login en toda la app

static FBDialog *loginDialog_;
@implementation FBLikeButton

@synthesize textColor = textColor_, buttonColor = buttonColor_, linkColor = linkColor_;


- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage andStyle:(FBLikeButtonStyle)style andColor:(FBLikeButtonColor)color
{
	if ((self = [super initWithFrame:frame]))
    {
		NSString *styleQuery=(style==FBLikeButtonStyleButtonCount? @"button_count" : (style==FBLikeButtonStyleBoxCount? @"box_count" : @"standard"));
        
		NSString *colorQuery=(color==FBLikeButtonColorDark? @"dark" : @"light");
        
		NSString *url =[NSString stringWithFormat:@"http://www.facebook.com/plugins/like.php?layout=%@&show_faces=true&width=%d&height=%d&action=like&colorscheme=%@&href=%@",
                        styleQuery, (int) frame.size.width, (int) frame.size.height, colorQuery, likePage];
        
		//Creamos una webview muy alta para evitar el scroll interno por la foto del usuario y otras cosas
		webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 300)];
		[self addSubview:webView_];
		[webView_ loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
		webView_.opaque = NO;
		webView_.backgroundColor = [UIColor clearColor];
		webView_.delegate = self;
		webView_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[[webView_ scrollView] setBounces:NO];
		self.backgroundColor=[UIColor clearColor];
		self.clipsToBounds=YES;
        
		[[NSNotificationCenter defaultCenter] addObserver:webView_ selector:@selector(reload) name:FB_LIKE_BUTTON_LOGIN_NOTIFICATION object:nil];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage{
	return [self initWithFrame:frame andUrl:likePage andStyle:FBLikeButtonStyleStandard andColor:FBLikeButtonColorLight];
}


- (void)dealloc
{    
	[[NSNotificationCenter defaultCenter] removeObserver:webView_ name:FB_LIKE_BUTTON_LOGIN_NOTIFICATION object:nil];
    
	self.linkColor=nil;
	self.textColor=nil;
	self.buttonColor=nil;
}


- (void) configureTextColors
{
    
	NSString *textColor=[self hexStringFromColor:textColor_];
	NSString *buttonColor=[self hexStringFromColor:buttonColor_];
	NSString *linkColor=[self hexStringFromColor:linkColor_];
    
	NSString *javascriptLinks = [NSString stringWithFormat:@"{"
                                 "var textlinks=document.getElementsByTagName('a');"
                                 "for(l in textlinks) { textlinks[l].style.color='#%@';}"
                                 "}", linkColor];
    
	NSString *javascriptSpans = [NSString stringWithFormat:@"{"
                                 "var spans=document.getElementsByTagName('span');"
                                 "for(s in spans) { if (spans[s].className!='liketext') { spans[s].style.color='#%@'; } else {spans[s].style.color='#%@';}}"
                                 "}", textColor, (buttonColor==nil? textColor : buttonColor)];
    
	//Lanzamos el javascript inmediatamente
	if (linkColor)
		[webView_ stringByEvaluatingJavaScriptFromString:javascriptLinks];
	if (textColor)
		[webView_ stringByEvaluatingJavaScriptFromString:javascriptSpans];
    
	//Programamos la ejecucion para cuando termine
	if (linkColor)
		[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTimeout(function () %@, 3000)", javascriptLinks]];
	if (textColor)
		[webView_ stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTimeout(function () %@, 3000)", javascriptSpans]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
	if (loginDialog_!=nil)
		return NO;
    
	// if user has to log in, open a new (modal) window
	if ([[[request URL] absoluteString] rangeOfString:@"http://m.facebook.com"].location!=NSNotFound){
		loginDialog_= [[FBCustomLoginDialog alloc] init];
		[loginDialog_ loadURL:[[request URL] absoluteString] get:nil];
		loginDialog_.delegate = self;
		[loginDialog_ show];
        
//		[loginDialog_.delegate retain];
        //Retenemos el boton que ha abierto el login para que pueda recibir la confirmacion correctamente
		return NO;
	}
    
    
	if (([[[request URL] absoluteString] rangeOfString:@"/connect/"].location!=NSNotFound) || ([[[request URL] absoluteString] rangeOfString:@"like.php"].location!=NSNotFound)){
		return YES;
	}
    
	NSLog(@"URL de Facebook no contemplada: %@", [[request URL] absoluteString]);
    
	return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[self configureTextColors];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Facebook Connect

- (void)dialogDidSucceed:(FBDialog*)dialog
{
	loginDialog_.delegate=nil;
	loginDialog_=nil;
    
	//Lanzamos la notificacion para que se actualicen los botones
	[[NSNotificationCenter defaultCenter] postNotificationName:FB_LIKE_BUTTON_LOGIN_NOTIFICATION object:nil];
}

/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog{
	[self dialogDidSucceed:dialog];
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url{
	[self dialogDidSucceed:loginDialog_];
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url{
	[self dialogDidSucceed:loginDialog_];
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog{
	[self dialogDidSucceed:loginDialog_];
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
	[self dialogDidSucceed:loginDialog_];
}


-(NSString*)hexStringFromColor:(UIColor *)uiColor
{    
    CGFloat rf,gf,bf,af;
    [uiColor getRed:&rf green:&gf blue: &bf alpha: &af];
    
    int r,g,b,a;
    
    r = (int)(255.0 * rf);
    g = (int)(255.0 * gf);
    b = (int)(255.0 * bf);
    a = (int)(255.0 * af);
    
    NSString *hexString  = [NSString stringWithFormat:@"%02x%02x%02x%02x",r,g,b,a];
    return hexString;
}

@end