//
//  ViewController.h
//  speakIt
//
//  Created by Mastek on 29/05/17.
//  Copyright © 2017 Mastek. All rights reserved.
//
//https://www.innoq.com/en/blog/vector-assets-in-ios-xcode/

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollForLogin;

- (IBAction)btnForSignIn:(id)sender;
- (IBAction)btnForForgotPassword:(id)sender;
- (IBAction)btnForSignUp:(id)sender;

@end

