//
//  HorizontalListAppDelegate.h
//  HorizontalList
//
//  Created by DaffodilAccount on 29/12/12.
//  Copyright (c) 2012 DaffodilAccount. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalListViewController;

@interface HorizontalListAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HorizontalListViewController *viewController;
@property(strong,nonatomic)UINavigationController *navController;

@end
