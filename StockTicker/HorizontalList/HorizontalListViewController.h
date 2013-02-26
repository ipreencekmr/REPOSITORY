//
//  HorizontalListViewController.h
//  HorizontalList
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2012 Prince Kumar Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockTiker.h"

@interface HorizontalListViewController : UIViewController<UIStockTickerDelegate,UITableViewDataSource>
{
    NSArray *objectArray,*objectArray2;
    NSTimer *tableTimer;
    StockTiker *stkticker,*stkticker2;
}

@end
