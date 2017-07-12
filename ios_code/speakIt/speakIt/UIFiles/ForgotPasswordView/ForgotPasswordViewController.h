//
//  ForgotPasswordViewController.h
//  speakIt
//
//  Created by Mastek on 06/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollForForgotPass;

- (IBAction)btnForBack:(id)sender;
- (IBAction)btnForResetPassword:(id)sender;
@end
