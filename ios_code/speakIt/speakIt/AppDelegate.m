//
//  AppDelegate.m
//  speakIt
//
//  Created by Mastek on 29/05/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "BaseViewController.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize ncontroller = _ncontroller;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //.. For One time login
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    // check if user is alraidy Login
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USER_MOBILENO]!=nil && ![[[NSUserDefaults standardUserDefaults] valueForKey:USER_MOBILENO] isEqualToString:@""]) {
        //Check authorization token expire or not
        
        NSString *un = [[NSUserDefaults standardUserDefaults] valueForKey:USER_MOBILENO];
        NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:USER_PASSWORD];
        //[BaseViewController getLoginAfterAuthExpire:un ispass:pass];
        
       // [self getLogin];
    }else{
        NSLog(@"login page call");
        ViewController *controller = (ViewController*)[mainStoryboard
                    instantiateViewControllerWithIdentifier: @"ViewController"];
        _ncontroller = [[UINavigationController alloc]initWithRootViewController:controller];
    }
    if(!_ncontroller){
        _ncontroller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"launch"];
    }
    
    self.window.rootViewController = _ncontroller;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)getLogin{
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
              UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
              HomeViewController *homeController = (HomeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
              _ncontroller = [[UINavigationController alloc]initWithRootViewController:homeController];
              
              
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
              //[self presentViewController:alert animated:YES completion:nil];
              [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
              
          }
      }
  }];
    [dataTask resume];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
