//
//  FBLikeButton.h
//  LikeApp
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2013 MaxMobility Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "FBCustomLoginDialog.h"

#define FB_LIKE_BUTTON_LOGIN_NOTIFICATION @"FBLikeLoginNotification"

typedef enum {
	FBLikeButtonStyleStandard,
	FBLikeButtonStyleButtonCount,
	FBLikeButtonStyleBoxCount
} FBLikeButtonStyle;

typedef enum {
	FBLikeButtonColorLight,
	FBLikeButtonColorDark
} FBLikeButtonColor;


@interface FBLikeButton : UIView<UIWebViewDelegate,FBLoginDialogDelegate,FBDialogDelegate>
{
	UIWebView *webView_;
	UIColor *textColor_;
	UIColor *linkColor_;
	UIColor *buttonColor_;
}
@property(retain) UIColor *textColor;
@property(retain) UIColor *linkColor;
@property(retain) UIColor *buttonColor;

- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage andStyle:(FBLikeButtonStyle)style andColor:(FBLikeButtonColor)color;
- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage;

@end
