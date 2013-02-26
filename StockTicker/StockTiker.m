//
//  StockTiker.m
//  HorizontalList
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2012 Prince Kumar Sharma. All rights reserved.


#import "StockTiker.h"

@implementation StockTiker
@synthesize tdelegate=_tdelegate;
@synthesize ttag=_ttag;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

-(void)start
{
   count=0;
   numberOfObjects=[_tdelegate numberOfRowsintickerView:self];
   NSLog(@"no of obejcts is %i",numberOfObjects);
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(moveObjects) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(checkPosition) userInfo:nil repeats:YES];
}


-(void)addElement:(UIView*)subView
{
    if (![self.subviews containsObject:(id)subView]) {
        [subView setFrame:CGRectMake(self.frame.size.width, 0, subView.frame.size.width, subView.frame.size.height)];
        [self addSubview:subView];
    }
}

-(void)checkPosition
{
    UIView *view=[self.tdelegate tickerView:self cellForRowAtIndex:count];
    CGRect rect=[view frame];
    
    float x=rect.origin.x+rect.size.width;
    
    if (x<300) {
        count=count+1;
        if (count==numberOfObjects) {
            count=0;
        }
    }
    
    UIView *subView=[self.tdelegate tickerView:self cellForRowAtIndex:count];
    
    [self addElement:subView];
    
    if ((rect.origin.x+rect.size.width)<0) {
        [view removeFromSuperview];
    }
}

-(void)moveObjects
{
    CGRect rect;
    for (UIView *view in self.subviews) {
        rect=[view frame];
        rect.origin.x--;
        [view setFrame:rect];
        [view setNeedsDisplayInRect:rect];
    }
}

@end
