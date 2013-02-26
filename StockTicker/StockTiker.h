//
//  StockTiker.h
//  HorizontalList
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2012 Prince Kumar Sharma. All rights reserved.
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
    int count;
    int numberOfObjects;
    id<UIStockTickerDelegate> tdelegate;
}

@property (assign) id<UIStockTickerDelegate>tdelegate;
@property(assign)NSUInteger ttag;

-(void)start;
@end
