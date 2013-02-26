//
//  HorizontalListAppDelegate.h
//  HorizontalList
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2012 Prince Kumar Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalListViewController;

@interface HorizontalListAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HorizontalListViewController *viewController;
@property(strong,nonatomic)UINavigationController *navController;

@end
