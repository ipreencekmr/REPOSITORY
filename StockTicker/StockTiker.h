//
//  StockTiker.h
//  HorizontalList
//
//  Created by Prince Kumar Sharma on 21/02/13.
//  Copyright (c) 2013 DaffodilAccount. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StockTiker;

@protocol UIStockTickerDelegate<NSObject>

@required
- (NSInteger)numberOfRowsintickerView:(StockTiker *)tickerView;
- (id)tickerView:(StockTiker*)tickerView cellForRowAtIndex:(int)index;
@end


@interface StockTiker : UIScrollView<UITableViewDataSource>
{
    @private
    int numberOfObjects;
    id<UIStockTickerDelegate> tdelegate;
}

@property (assign) id<UIStockTickerDelegate>tdelegate;
@property(assign)NSUInteger ttag;
-(void)start;
@end
