



#import "HorizontalListViewController.h"
#import "XMLReader.h"

@interface HorizontalListViewController ()

@end

@implementation HorizontalListViewController


-(NSDictionary*)getTickerBSE
{
    NSString *stringURL=[NSString stringWithFormat:@"http://m.portfoliotracker.in/mobilemiddleware/ticker.aspx?category=bse30&mobno=9831219492"];
    NSURL *url=[NSURL URLWithString:stringURL];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    NSString *responseString=[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    responseString=[responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSLog(@"response string is %@",responseString);
    
    NSDictionary *dictionary=[XMLReader dictionaryForXMLString:responseString error:&error];
    NSLog(@"dictionary is %@",dictionary);
    return dictionary;
}

-(UILabel*)getTickerObject:(NSDictionary*)dics
{
    UILabel *name,*c,*ccp;
    name=[[UILabel alloc] init];
    c=[[UILabel alloc] init];
    ccp=[[UILabel alloc] init];
    
    name.backgroundColor=[UIColor clearColor];
    ccp.backgroundColor=[UIColor clearColor];
    c.backgroundColor=[UIColor clearColor];
    
    UIImageView *imgView=[[UIImageView alloc] init];
    
    name.text=[NSString stringWithFormat:@"%@:",[[dics valueForKey:@"NAME"] valueForKey:@"text"]];
    ccp.text=[[dics valueForKey:@"CCP"] valueForKey:@"text"];
    c.text=[[dics valueForKey:@"C"] valueForKey:@"text"];
    
    name.font=[UIFont systemFontOfSize:12];
    c.font=[UIFont systemFontOfSize:12];
    ccp.font=[UIFont systemFontOfSize:12];
    
    [name sizeToFit];
    [c sizeToFit];
    [ccp sizeToFit];
    
    float cValue=[[[dics valueForKey:@"C"] valueForKey:@"text"] floatValue];
    
    if (cValue<0) {
        c.textColor=[UIColor redColor];
        ccp.textColor=[UIColor redColor];
        imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rArrow.png"]];
    }else
    {
        c.textColor=[UIColor greenColor];
        ccp.textColor=[UIColor greenColor];
        imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gArrow.png"]];
    }
    
    name.textColor=[UIColor whiteColor];
    
    CGRect rect;
    
    CGSize nameSize=name.frame.size;
    CGSize ccpSize=ccp.frame.size;
    CGSize cSize=c.frame.size;
    
    rect=CGRectMake(nameSize.width,1, ccpSize.width, ccpSize.height);
    [ccp setFrame:rect];
    
    rect=CGRectMake(ccpSize.width+nameSize.width,1,15,15);
    [imgView setFrame:rect];
    imgView.backgroundColor=[UIColor clearColor];
    
    rect=CGRectMake(15+ccpSize.width+nameSize.width, 1, cSize.width, cSize.height);
    [c setFrame:rect];
    
    UILabel *tickerLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, nameSize.width+ccpSize.width+15+cSize.width, 16)];
    
    tickerLabel.backgroundColor=[UIColor clearColor];
    [tickerLabel addSubview:name];
    [tickerLabel addSubview:ccp];
    [tickerLabel addSubview:imgView];
    [tickerLabel addSubview:c];
    
    return tickerLabel;
}


-(void)BSE_Ticker
{
    NSDictionary *bsedictionary=[[NSDictionary alloc] initWithDictionary:[self getTickerBSE]];
    
    NSArray *bseArray=[[NSArray alloc] initWithArray:[[bsedictionary valueForKey:@"page"] valueForKey:@"OBJ"]];
    UILabel *label=[[UILabel alloc] init];
    
    NSMutableArray *l = [[NSMutableArray alloc] init];
    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in bseArray)
    {
        label=[self getTickerObject:dic];
        [label layoutSubviews];
        [sizes addObject:[NSValue valueWithCGSize:label.frame.size]];
        [l addObject:label];
    }
    
    objectArray=[[NSArray alloc] initWithArray:l];
     NSLog(@"object array is %@",objectArray);
    
    [stkticker start];
}

- (void)viewDidLoad
{
    objectArray=[[NSArray alloc] init];
    
    stkticker=[[StockTiker alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    stkticker.tdelegate=self;
    stkticker.ttag=0;
    [self.view addSubview:stkticker];
    
    
    [self BSE_Ticker];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITickerView delegate method

- (NSInteger)numberOfRowsintickerView:(StockTiker *)tickerView
{
    return [objectArray count];
}

- (id)tickerView:(StockTiker*)tickerView cellForRowAtIndex:(int)index
{
  return [objectArray objectAtIndex:index];
}

@end
