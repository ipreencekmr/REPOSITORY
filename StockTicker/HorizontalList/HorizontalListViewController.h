//
//  HorizontalListViewController.h
//  HorizontalList
//
//  Created by DaffodilAccount on 29/12/12.
//  Copyright (c) 2012 DaffodilAccount. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockTiker.h"

@interface HorizontalListViewController : UIViewController<UIStockTickerDelegate,UITableViewDataSource>
{
    NSArray *objectArray;
    NSTimer *tableTimer;
    StockTiker *stkticker;
}

@end
