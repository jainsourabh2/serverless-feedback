//
//  PageContentViewController.m
//  speakIt
//
//  Created by Mastek on 15/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "PageContentViewController.h"
#import "SVProgressHUD.h"
#import "CouponViewController.h"
#import "ThankYouViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController
@synthesize tapRateView = _tapRateView;
@synthesize dictForQueWithFeed;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"dictForQueWithFeed: %@",dictForQueWithFeed);
    
    //..start for rating star
    _tapRateView = [[RSTapRateView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.lblQuestion.bounds.origin.y + 350, self.view.bounds.size.width, 35.f)];
    _tapRateView.delegate = self;
    _tapRateView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tapRateView];
    //..end for rating star
}

-(void)viewDidAppear:(BOOL)animated
{
    self.screenNumber.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.indexPage +1,(long)self.totalSize];
    self.lblQuestion.text = [NSString stringWithFormat:@"%@",self.strQuestion];
    NSLog(@"Total: %ld",(long)_totalSize);
    
    if (_totalSize == _indexPage+1) {
        NSLog(@"=");
        _btnForNextObj.hidden = YES;
        _btnForFinishObj.hidden = NO;
    }else{
        NSLog(@"x");
        _btnForNextObj.hidden = NO;
        
    }
}

#pragma mark -
#pragma mark RSTapRateViewDelegate
- (void)tapDidRateView:(RSTapRateView*)view rating:(NSInteger)rating {
    NSLog(@"lbl:%@",_lblQuestion.text);
    NSString *strQ = _lblQuestion.text;
    NSString *ratingVal = [NSString stringWithFormat: @"%ld", (long)rating];
    [dictForQueWithFeed setObject:ratingVal forKey:strQ];
    NSLog(@"Current rating: %li", (long)rating);
    NSLog(@"Dict for rate: %@",dictForQueWithFeed);
}


- (IBAction)btnForNext:(id)sender {
    [self.delegatesNext goForNextViewPager:@"NEXT"];
}

#pragma mark - Post feedback
- (IBAction)btnForFinish:(id)sender
{
    NSLog(@"id: %@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_PLACEID]);
    NSString *uId = @"12345";
    User *user = [[User alloc] init];
    user.userAuthorization = [[NSUserDefaults standardUserDefaults] valueForKey:USER_AUTHORIZATION];
    NSArray *keys=[dictForQueWithFeed allKeys];
    NSArray *values=[dictForQueWithFeed allValues];
    
    NSLog(@"key-%@",keys);
    NSLog(@"valu- %@",values);
    
    //https://dl9xeqa7gf.execute-api.us-west-2.amazonaws.com/dev/feedback/postfeedback
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    //For using dictionary with array parameter
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] valueForKey:USER_PLACEID], @"placeid",
                            uId, @"userid",
                            keys, @"questions",
                            values, @"feedback",
                            nil];
    NSLog(@"params-->%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //..Start Custom add "Authorization" header
    [manager.requestSerializer setValue:user.userAuthorization forHTTPHeaderField:@"Authorization"];
    //..End
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSLog(@"Url:%@",[NSString stringWithFormat:@"%@feedback/postfeedback",WEBSERVICEURL]);
    
    [manager POST:[NSString stringWithFormat:@"%@feedback/postfeedback",WEBSERVICEURL] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON--------- %@", responseObject);
        [SVProgressHUD dismiss];
        [self.view setUserInteractionEnabled:YES];
        
        NSDictionary *tempDict = (NSDictionary*)responseObject;
        NSLog(@"s: %@",[[tempDict valueForKey:@"statusCode"] stringValue]);
        
        if ([[[tempDict valueForKey:@"statusCode"] stringValue] isEqualToString:@"200"]) {
            NSString *strCouponName = [[tempDict valueForKey:@"body"] objectForKey:@"couponName"];
            NSString *strCouponDesc = [[tempDict valueForKey:@"body"] objectForKey:@"couponDesc"];
            NSString *strCouponCode = [[tempDict valueForKey:@"body"] objectForKey:@"couponCode"];
            NSString *strCouponExpiry = [[tempDict valueForKey:@"body"] objectForKey:@"couponExpiry"];
            NSLog(@"strCouponName: %@ \n %@ \n %@ \n %@",strCouponName, strCouponDesc, strCouponCode, strCouponExpiry);
            CouponViewController *coupon = GETVIEWCONTROLLERFROMIDENTIFIER(@"CouponViewController");
            coupon.detailCouponName = strCouponName;
            coupon.detailCouponDesc = strCouponDesc;
            coupon.detailCouponCode = strCouponCode;
            coupon.detailCouponExpiry = strCouponExpiry;
            //[self.navigationController pushViewController:coupon animated:NO];
            [self presentViewController:coupon animated:NO completion:^{
                
            }];
            [SVProgressHUD dismiss];
        }else
        {
            NSLog(@"status code 201");
            [SVProgressHUD dismiss];
            ThankYouViewController *thankView = GETVIEWCONTROLLERFROMIDENTIFIER(@"ThankYouViewController");
            //[self.navigationController pushViewController:thankView animated:NO];
            [self presentViewController:thankView animated:NO completion:^{
                
            }];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlert:@"Don't have any data.."];
    }];
}

-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button Ok");
                                                          }];
    
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
