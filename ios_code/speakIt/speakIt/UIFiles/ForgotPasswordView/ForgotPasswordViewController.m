//
//  ForgotPasswordViewController.m
//  speakIt
//
//  Created by Mastek on 06/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (IBAction)btnForBack:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnForResetPassword:(id)sender{
    if([self validateInput]){
    }
}

-(BOOL)validateInput{
    if([Constant getTrimmedString:_txtEmail.text].length ==0){
        [self showAlertWithTitle:@"" andMsg:@"Enter Email!"];
        return NO;
    }else if (![Constant isValidEmailID:[Constant getTrimmedString:_txtEmail.text]]){
        [self showAlertWithTitle:@"" andMsg:@"Enter valid email ID!"];
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
        [_txtEmail resignFirstResponder];
    }
    return NO;
}
@end
