//
//  SignupViewController.m
//  speakIt
//
//  Created by Mastek on 02/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "SignupViewController.h"
#import "OtpViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Increasse setcontent size for boardPayNow scrollView
    [_scrollForSignUp setContentSize:CGSizeMake(_scrollForSignUp.frame.size.width, _scrollForSignUp.frame.size.height + 150)];
}

- (IBAction)btnForBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnForCheckTOC:(id)sender {
    if (checkboxSelected == 0){
        [_btnForCheckTOCObj setSelected:YES];
        checkboxSelected = 1;
        
        //_btnForCheckTOCObj.imageEdgeInsets = UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0);
        //        [_btnForTermsActionObj setBackgroundImage:[UIImage imageNamed:@"Uncheck-box.png"] forState:UIControlStateSelected];
        [_btnForCheckTOCObj setImage:[UIImage imageNamed:@"CheckBoxEmpty.png"] forState:UIControlStateNormal];
        
        //Using for check terms & condition
        _isCheck = @"FALSE";
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_isCheck forKey:CHECKTERM];
        [userDefault synchronize];
        NSLog(@"Check val = %@",_isCheck);
        
    } else {
        [_btnForCheckTOCObj setSelected:NO];
        checkboxSelected = 0;
        
        //_btnForCheckTOCObj.imageEdgeInsets = UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0);
        //        [_btnForTermsActionObj setBackgroundImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
        [_btnForCheckTOCObj setImage:[UIImage imageNamed:@"CheckBoxMarked.png"] forState:UIControlStateNormal];
        
        //Using for check terms & condition
        _isCheck = @"TRUE";
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_isCheck forKey:CHECKTERM];
        [userDefault synchronize];
        NSLog(@"Check val = %@",_isCheck);
        
    }
}

- (IBAction)btnForSignUp:(id)sender {
    if([self validateSignUp]){
        User *user = [[User alloc] init];
        user.userEmail = [Constant getTrimmedString:_txtEmail.text];
        NSString *strMobCode = @"+91";
        NSString *strMobileNo = [Constant getTrimmedString:_txtMobile.text];
        user.userMobile = [strMobCode stringByAppendingString:strMobileNo];
        user.userPassword = [Constant getTrimmedString:_txtPassword.text];
        
        [SVProgressHUD showWithStatus:@"Please wait.."];
        [self.view setUserInteractionEnabled:NO];
        
        NSString *strURL = [NSString stringWithFormat:@"%@loginUser/createUser",WEBSERVICEURL];
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
                                user.userEmail, @"email",
                                user.userMobile, @"mobile",
                                user.userMobile, @"username",
                                user.userPassword, @"password", nil];
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
                            [[NSUserDefaults standardUserDefaults] setObject:user.userMobile forKey:USER_MOBILENO];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [SVProgressHUD dismiss];
                            OtpViewController *otpView = GETVIEWCONTROLLERFROMIDENTIFIER(@"OtpViewController");
                            [self.navigationController pushViewController:otpView animated:NO];
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

-(BOOL)validateSignUp{
    if([Constant getTrimmedString:_txtEmail.text].length ==0){
        [self showAlertWithTitle:@"" andMsg:@"Enter email!"];
        return NO;
    }else if (![Constant isValidEmailID:[Constant getTrimmedString:_txtEmail.text]]){
        [self showAlertWithTitle:@"" andMsg:@"Enter valid email ID!"];
        return NO;
    }else if ([Constant getTrimmedString:_txtMobile.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Enter mobile number!"];
        return NO;
    }else if([Constant getTrimmedString:_txtMobile.text].length < 10){
        [self showAlertWithTitle:@"" andMsg:@"Enter valid mobile number!"];
        return NO;
    }else if ([Constant getTrimmedString:_txtPassword.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Enter password!"];
        return NO;
    }else if ([Constant getTrimmedString:_txtPassword.text].length < 7){
        [self showAlertWithTitle:@"" andMsg:@"Password length should be more than 7 characters!"];
        return NO;
    }else if ([Constant getTrimmedString:_txtConfirmPassword.text].length == 0){
        [self showAlertWithTitle:@"" andMsg:@"Enter confirm password!"];
        return NO;
    }else if(![[Constant getTrimmedString:_txtPassword.text] isEqualToString:[Constant getTrimmedString:_txtConfirmPassword.text]]){
        [self showAlertWithTitle:@"" andMsg:@"Password mis-matched!"];
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
    if(textField == _txtEmail){
        [_txtMobile becomeFirstResponder];
    }else if (textField ==_txtMobile){
        [_txtPassword becomeFirstResponder];
    }else if (textField ==_txtPassword){
        [_txtConfirmPassword becomeFirstResponder];
    }else if (textField ==_txtConfirmPassword){
        [_txtConfirmPassword resignFirstResponder];
    }
    return NO;
}

//Only 10 numbar enter for textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == _txtMobile){
        if(textField.text.length >=10 && range.length == 0)
            return NO;
    }
    return YES;
    
}


#pragma mark-- Response
-(void)getWebResponse:(NSString *)webresponse
{
    [SVProgressHUD dismiss];
    [self.view setUserInteractionEnabled:YES];
    NSLog(@"response:%@",webresponse);/*
    if(webresponse == nil){
        [self showAlertWithTitle:@"" andMsg:@"Please check your inernet connection..!"];
        return;
    }
    NSError *err = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[webresponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    if(!err){
        //The results from Google will be an array obtained from the NSDictionary object with the key "results".
        NSArray *arrData = [dictionary objectForKey:@"results"];
        
        //Write out the data to the console.
        NSLog(@"Google Data: %@", arrData);
    }else{
        [self showAlertWithTitle:@"" andMsg:@"Don't have any data.."];
    }
    */
}
@end
