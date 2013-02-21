//
//  LikeAppViewController.h
//  LikeApp
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2013 MaxMobility Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "FBCustomLoginDialog.h"
#import "Accounts/Accounts.h"
#import "LikeAppAppDelegate.h"

#define FB_LIKE_BUTTON_LOGIN_NOTIFICATION @"FBLikeLoginNotification"

@interface LikeAppViewController : UIViewController
{
    LikeAppAppDelegate *appDelegate;
}
- (IBAction)likepageonFB:(id)sender;
-(void)like;
@end
