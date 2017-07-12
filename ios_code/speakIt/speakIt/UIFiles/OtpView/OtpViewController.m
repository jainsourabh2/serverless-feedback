//
//  OtpViewController.m
//  speakIt
//
//  Created by Mastek on 12/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "OtpViewController.h"
#import "SVProgressHUD.h"
#import "ViewController.h"

@interface OtpViewController ()

@end

@implementation OtpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (IBAction)btnForBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnForSubmitOtp:(id)sender {
    if([self validateOtp]){
        User *user = [[User alloc] init];
        user.userPinOne = [Constant getTrimmedString:_txtFirst.text];
        user.userPinTwo = [Constant getTrimmedString:_txtSecond.text];
        user.userPinThree = [Constant getTrimmedString:_txtThird.text];
        user.userPinFour = [Constant getTrimmedString:_txtFour.text];
        user.userPinFive = [Constant getTrimmedString:_txtFive.text];
        user.userPinSix = [Constant getTrimmedString:_txtSix.text];
        
        NSString *strCode=[NSString stringWithFormat:@"%@%@%@%@%@%@",user.userPinOne,user.userPinTwo,user.userPinThree,user.userPinFour,user.userPinFive,user.userPinSix];
        NSLog(@"strCode: %@",strCode);
        
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [self.view setUserInteractionEnabled:NO];
        
        NSString *strURL = [NSString stringWithFormat:@"%@loginUser/confirmUser",WEBSERVICEURL];
        NSLog(@"OTP url=%@",strURL);
        
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
                                [[NSUserDefaults standardUserDefaults] valueForKey:USER_MOBILENO], @"username",
                                strCode, @"code", nil];
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
                      [SVProgressHUD dismiss];
                      ViewController *loginView = GETVIEWCONTROLLERFROMIDENTIFIER(@"ViewController");
                      [self.navigationController pushViewController:loginView animated:NO];
                  }else
                  {
                      NSLog(@"status code 201");
                      [self showAlertWithTitle:@"" andMsg:[textData valueForKey:@"message"]];
                      [SVProgressHUD dismiss];
                  }
              }
          }];
        [dataTask resume];
    }
}

- (IBAction)btnForResendOTP:(id)sender {
    //if([self validateOtp]){
        
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [self.view setUserInteractionEnabled:NO];
        
        NSString *strURL = [NSString stringWithFormat:@"%@loginUser/resendConfirmation",WEBSERVICEURL];
        NSLog(@"Rsend OTP url=%@",strURL);
        
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
                                [[NSUserDefaults standardUserDefaults] valueForKey:USER_MOBILENO], @"username",nil];
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
                      [SVProgressHUD dismiss];
                      [self showAlertWithTitle:@"" andMsg:[textData valueForKey:@"message"]];
                  }else
                  {
                      NSLog(@"status code 201");
                      [self showAlertWithTitle:@"" andMsg:[textData valueForKey:@"message"]];
                      [SVProgressHUD dismiss];
                  }
              }
          }];
        [dataTask resume];
   // }
}

-(BOOL)validateOtp{
    if([Constant getTrimmedString:_txtFirst.text].length ==0){
        [self showAlertWithTitle:@"" andMsg:@"Please Enter OTP"];
        return NO;
    }else if ([Constant getTrimmedString:_txtSecond.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Please Enter OTP"];
        return NO;
    }else if ([Constant getTrimmedString:_txtThird.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Please Enter OTP"];
        return NO;
    }else if ([Constant getTrimmedString:_txtFour.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Please Enter OTP"];
        return NO;
    }else if ([Constant getTrimmedString:_txtFive.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Please Enter OTP"];
        return NO;
    }else if ([Constant getTrimmedString:_txtSix.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Please Enter OTP"];
        return NO;
    }
    
    return YES;
}

-(void)showAlertWithTitle:(NSString *)title andMsg:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button Ok");
                                                          }];
    
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Textfield delegate methode
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == _txtFirst){
        [_txtSecond becomeFirstResponder];
    }else if (textField ==_txtSecond){
        [_txtThird becomeFirstResponder];
    }else if (textField ==_txtThird){
        [_txtFour becomeFirstResponder];
    }else if (textField ==_txtFour){
        [_txtFive becomeFirstResponder];
    }else if (textField ==_txtFive){
        [_txtSix becomeFirstResponder];
    }else if (textField ==_txtSix){
        [_txtSix resignFirstResponder];
    }
    return NO;
}
@end
