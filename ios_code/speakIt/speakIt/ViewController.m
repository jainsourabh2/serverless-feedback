//
//  ViewController.m
//  speakIt
//
//  Created by Mastek on 29/05/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "ViewController.h"
#import "SignupViewController.h"
#import "ForgotPasswordViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)btnForSignIn:(id)sender {
    if([self validateInput]){
        User *user = [[User alloc] init];
        NSString *strMobCode = @"+91";
        NSString *strMobileNo = [Constant getTrimmedString:_txtUsername.text];
        user.userUsername = [strMobCode stringByAppendingString:strMobileNo];
        user.userPass = [Constant getTrimmedString:_txtPassword.text];
        
        //..Custom data
//        user.userUsername = @"+919096756844";
//        user.userPass = @"Prashant@123";
        
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [self.view setUserInteractionEnabled:NO];
        
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
                                user.userUsername, @"username",
                                user.userPass, @"password", nil];
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
                      [[NSUserDefaults standardUserDefaults] setObject:user.userUsername forKey:USER_MOBILENO];
                      [[NSUserDefaults standardUserDefaults] setObject:[Constant getTrimmedString:_txtPassword.text] forKey:USER_PASSWORD];
                      [[NSUserDefaults standardUserDefaults] setObject:[textData valueForKey:@"authorization"] forKey:USER_AUTHORIZATION];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                      [SVProgressHUD dismiss];
                      HomeViewController *homeView = GETVIEWCONTROLLERFROMIDENTIFIER(@"HomeViewController");
                      [self.navigationController pushViewController:homeView animated:NO];
                  }else if ([[textData valueForKey:@"message"] isEqualToString:@"Internal server error"]){
                      NSLog(@"status code 201");
                      [self showAlertWithTitle:@"" andMsg:@"Invalid username/password. Please try again"];
                      [self.view setUserInteractionEnabled:YES];
                      [SVProgressHUD dismiss];
                  }
              }
          }];
        [dataTask resume];
    }
}

-(BOOL)validateInput{
    if([Constant getTrimmedString:_txtUsername.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Enter Username!"];
        return NO;
    }else if([Constant getTrimmedString:_txtUsername.text].length < 10){
        [self showAlertWithTitle:@"" andMsg:@"Enter valid username/Mobile number!"];
        return NO;
    }else if ([Constant getTrimmedString:_txtPassword.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Enter password!"];
        return NO;
    }else if([Constant getTrimmedString:_txtPassword.text].length < 7){
        [self showAlertWithTitle:@"" andMsg:@"Password length should be more than 7 characters!"];
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

- (IBAction)btnForForgotPassword:(id)sender {
    ForgotPasswordViewController *forgotView = GETVIEWCONTROLLERFROMIDENTIFIER(@"ForgotPasswordViewController");
    [self.navigationController pushViewController:forgotView animated:NO];
}

- (IBAction)btnForSignUp:(id)sender {
    SignupViewController *signUpView = GETVIEWCONTROLLERFROMIDENTIFIER(@"SignupViewController");
    [self.navigationController pushViewController:signUpView animated:NO];
}

#pragma mark - Textfield delegate methode
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == _txtUsername){
        [_txtPassword becomeFirstResponder];
    }else if (textField ==_txtPassword){
        [_txtPassword resignFirstResponder];
    }
    return NO;
}

//Only 10 numbar enter for textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == _txtUsername){
        if(textField.text.length >=10 && range.length == 0)
            return NO;
    }
    return YES;
    
}

@end
