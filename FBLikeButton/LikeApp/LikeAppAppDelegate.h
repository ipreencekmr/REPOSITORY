//
//  LikeAppAppDelegate.h
//  LikeApp
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2013 MaxMobility Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@class LikeAppViewController;

@interface LikeAppAppDelegate : UIResponder <UIApplicationDelegate,FBLoginDialogDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LikeAppViewController *viewController;
- (void)openSession;
@end
