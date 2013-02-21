//
//  LikeAppViewController.m
//  LikeApp
//
//  Created by Prince Kumar Sharma on 20/02/13.
//  Copyright (c) 2013 MaxMobility Pvt. Ltd. All rights reserved.
//

#import "LikeAppViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "JSONKit.h"

static FBDialog *loginDialog_;

@interface LikeAppViewController ()

@end

@implementation LikeAppViewController

- (void)viewDidLoad
{
    appDelegate=(LikeAppAppDelegate*)[UIApplication sharedApplication].delegate;
//   157498974407846
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)likepageonFB:(id)sender
{
    if ([[FBSession activeSession] isOpen]) {
        [self like];
    }else
    {
        [appDelegate openSession];
    }
}

-(void)like
{
    NSString *likePage=@"http://in.yahoo.com/?p=us";
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   likePage, @"object",[[NSUserDefaults standardUserDefaults] valueForKey:@"token"],@"access_token",
                                   nil];
    
    [FBRequestConnection startWithGraphPath:@"/me/og.likes" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"liked with id %@",[result valueForKey:@"id"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"result is %@",result);
    }];
}

@end
