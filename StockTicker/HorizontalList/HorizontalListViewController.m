
#import "HorizontalListViewController.h"
#import "JSONKit.h"

@interface HorizontalListViewController ()

@end

@implementation HorizontalListViewController


- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    stkticker=[[StockTiker alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    stkticker.tdelegate=self;
    stkticker.ttag=0;
    [stkticker setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar addSubview:stkticker];
    
    stkticker2=[[StockTiker alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    stkticker2.tdelegate=self;
    stkticker2.ttag=1;
    [stkticker2 setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar addSubview:stkticker2];
    
    [self performSelector:@selector(receiveData) withObject:nil];
    [super viewDidLoad];
}


#pragma mark- Receive data from API.

-(void)receiveData
{
    NSArray *stockArray=[[NSArray alloc] initWithArray:[self getStocks]];
    
    UILabel *objLbl=[[UILabel alloc] init];
    NSMutableArray *l = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in stockArray) {
        objLbl=[self getTickerObject:dic];
        [l addObject:objLbl];
    }
    objectArray=[[NSArray alloc] initWithArray:l];
    
    [l removeAllObjects];
    
    NSArray *currencyArray=[[NSArray alloc] initWithArray:[self getCurrencies]];
    
    UILabel *cObjLbl=[[UILabel alloc] init];
    for (NSDictionary *dic in currencyArray) {
        cObjLbl=[self getCurrencyObject:[[dic valueForKey:@"resource"] valueForKey:@"fields"]];
        [l addObject:cObjLbl];
    }
    objectArray2=[[NSArray alloc] initWithArray:l];
    
    [stkticker start];
    [stkticker2 start];
}

#pragma mark- get Stocks

-(NSArray*)getStocks
{
    NSString *stringURL=[NSString stringWithFormat:@"http://finance.google.com/finance/info?client=ig&q=NASDAQ,MSFT,AAPL,GOOG,YHOO,DIS,FTSE,DAX"];
    NSURL *url=[NSURL URLWithString:stringURL];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    NSString *responseString=[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    responseString=[responseString stringByReplacingOccurrencesOfString:@"//" withString:@""];
    
    NSArray *array=[responseString objectFromJSONStringWithParseOptions:JKParseOptionStrict];
    
    if (array.count!=0) {
        return array;
    }
    return nil;
}

#pragma mark- get Currencies

-(NSArray*)getCurrencies
{
    NSString *stringURL=[NSString stringWithFormat:@"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"];
    NSURL *url=[NSURL URLWithString:stringURL];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *responseString=[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    responseString=[responseString stringByReplacingOccurrencesOfString:@"//" withString:@""];
    
    NSDictionary *dictionary=[responseString objectFromJSONStringWithParseOptions:JKParseOptionStrict];
    
    NSArray *returnArray=[[dictionary valueForKey:@"list"] valueForKey:@"resources"];
    
    if (returnArray.count!=0) {
        return returnArray;
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Getting Individual Objects 

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
    
    name.text=[NSString stringWithFormat:@"%@ ",[dics valueForKey:@"t"]];
    ccp.text=[dics valueForKey:@"el_cur"];
    c.text=[dics valueForKey:@"c"];
    
    name.font=[UIFont systemFontOfSize:12];
    c.font=[UIFont systemFontOfSize:12];
    ccp.font=[UIFont systemFontOfSize:12];
    
    [name sizeToFit];
    [c sizeToFit];
    [ccp sizeToFit];
    
    float cValue=[[dics valueForKey:@"c"] floatValue];
    
    if (cValue<0) {
        c.textColor=[UIColor redColor];
        imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rArrow.png"]];
    }else
    {
        c.textColor=[UIColor greenColor];
        imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gArrow.png"]];
    }
    
    name.textColor=[UIColor whiteColor];
    ccp.textColor=[UIColor whiteColor];
    
    CGRect rect;
    
    CGSize nameSize=name.frame.size;
    CGSize ccpSize=ccp.frame.size;
    CGSize cSize=c.frame.size;
    
    rect=CGRectMake(nameSize.width,0, ccpSize.width, ccpSize.height);
    [ccp setFrame:rect];
    
    rect=CGRectMake(ccpSize.width+nameSize.width,0,15,15);
    [imgView setFrame:rect];
    imgView.backgroundColor=[UIColor clearColor];
    
    rect=CGRectMake(15+ccpSize.width+nameSize.width, 0, cSize.width, cSize.height);
    [c setFrame:rect];
    
    UILabel *tickerLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, nameSize.width+ccpSize.width+15+cSize.width, 16)];
    
    tickerLabel.backgroundColor=[UIColor clearColor];
    [tickerLabel addSubview:name];
    [tickerLabel addSubview:ccp];
    [tickerLabel addSubview:imgView];
    [tickerLabel addSubview:c];
    
    return tickerLabel;
}


-(UILabel*)getCurrencyObject:(NSDictionary*)dics
{
    UILabel *name,*ccp;
    name=[[UILabel alloc] init];
    ccp=[[UILabel alloc] init];
    
    name.backgroundColor=[UIColor clearColor];
    ccp.backgroundColor=[UIColor clearColor];
    
    UIImageView *imgView=[[UIImageView alloc] init];
    
    name.text=[NSString stringWithFormat:@"%@:",[[[dics valueForKey:@"symbol"] componentsSeparatedByString:@"="] objectAtIndex:0]];
    ccp.text=[NSString stringWithFormat:@"%.2f",[[dics valueForKey:@"price"] floatValue]];
    
    name.font=[UIFont systemFontOfSize:12];
    name.textColor=[UIColor whiteColor];
    
    ccp.font=[UIFont systemFontOfSize:12];
    ccp.textColor=[UIColor greenColor];
    
    [name sizeToFit];
    [ccp sizeToFit];
    
    [ccp setFrame:CGRectMake(name.frame.size.width, 0, ccp.frame.size.width, ccp.frame.size.height)];
    UILabel *tickerLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,name.frame.size.width+ccp.frame.size.width,16)];
    
    tickerLabel.backgroundColor=[UIColor clearColor];
    [tickerLabel addSubview:name];
    [tickerLabel addSubview:ccp];
    [tickerLabel addSubview:imgView];
    
    return tickerLabel;
}

#pragma mark- UITickerView delegate method

- (NSInteger)numberOfRowsintickerView:(StockTiker *)tickerView
{
    if (tickerView.ttag==0) {
        return [objectArray count];
    }
    
    return [objectArray2 count];
}

- (id)tickerView:(StockTiker*)tickerView cellForRowAtIndex:(int)index
{
    if (tickerView.ttag==0) {
        return [objectArray objectAtIndex:index];
    }
  
    return [objectArray2 objectAtIndex:index];
}

@end
