//
//  LSViewController.m
//  speakIt
//
//  Created by Mastek on 07/07/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "LSViewController.h"
#import "Constant.h"
#import "HomeViewController.h"
#import "SVProgressHUD.h"
#import "ViewController.h"

@interface LSViewController ()

@end

@implementation LSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:USER_MOBILENO] isEqualToString:@""] && [[[NSUserDefaults standardUserDefaults] valueForKey:USER_PASSWORD] isEqualToString:@""]) {
        //Check authorization token expire or not
        ViewController *viewContr = GETVIEWCONTROLLERFROMIDENTIFIER(@"ViewController");
        UINavigationController *navContr = [[UINavigationController alloc]initWithRootViewController:viewContr];
        [self.navigationController pushViewController:navContr animated:NO];
        //[self presentViewController:viewContr animated:NO completion:^{
        //}];
        
        
    }else{
        [self getALogin];
    }
    
    
}

-(void)getALogin
{
    NSString *un = [[NSUserDefaults standardUserDefaults] valueForKey:USER_MOBILENO];
    NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:USER_PASSWORD];
    
    //..Custom data
    //        user.userUsername = @"+919096756844";
    //        user.userPass = @"Prashant@123";
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    
    NSString *strURL = [NSString stringWithFormat:@"%@loginUser/authenticateUser",WEBSERVICEURL];
    NSLog(@"SignUp url=%@",strURL);
    
    NSError *error;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:strURL];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:45.0];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPMethod:@"POST"];
    //For using string parameter
    //NSString *params =@"name=Ravi&loc=India&age=31&submit=true";
    
    //For using dictionary with array parameter
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            un, @"username",
                            pass, @"password", nil];
    NSLog(@"params-->%@",params);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    //For using string parameter
    //[urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
      //NSLog(@"Response:%@ %@\n", response, error);
      if(error == nil)
      {
          //.. for string
          //NSString * textData = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
          //.. For dictionary
          NSDictionary *textData  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          NSLog(@"success");
          NSLog(@"Data = %@",textData);
          
          NSLog(@"s: %@",[[textData valueForKey:@"statusCode"] stringValue]);
          
          if ([[[textData valueForKey:@"statusCode"] stringValue] isEqualToString:@"200"])
          {
              //Save data on userdefaults
              [[NSUserDefaults standardUserDefaults] setObject:[textData valueForKey:@"authorization"] forKey:USER_AUTHORIZATION];
              [[NSUserDefaults standardUserDefaults] synchronize];
              
              [SVProgressHUD dismiss];
              //                  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
              //                  HomeViewController *home= [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
              //                  UINavigationController *navPoint = [[UINavigationController alloc] initWithRootViewController:home];
              //                  [self.navigationController pushViewController:navPoint animated:NO];
              
              
              
              HomeViewController *homeView = GETVIEWCONTROLLERFROMIDENTIFIER(@"HomeViewController");
              [self presentViewController:homeView animated:NO completion:^{
                  
              }];
              
              
              /*
               UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
               HomeViewController *homeController = (HomeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
               //_ncontroller = [[UINavigationController alloc]initWithRootViewController:homeController];
               [self presentViewController:homeController animated:NO completion:^{
               
               }];
               */
              
              
              
              
          }else if ([[textData valueForKey:@"message"] isEqualToString:@"Internal server error"]){
              NSLog(@"status code 201");
              [SVProgressHUD dismiss];
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                             message:@"Invalid username/password. Please try again"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                        NSLog(@"You pressed button Ok");
                                                                    }];
              
              [alert addAction:firstAction];
              [self presentViewController:alert animated:YES completion:nil];
              
              
          }
      }
  }];
    [dataTask resume];
}

@end
