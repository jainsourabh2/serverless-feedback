//
//  SignupViewController.h
//  speakIt
//
//  Created by Mastek on 02/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface SignupViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,WebResponseProtocol>
{
    BOOL checkboxSelected;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollForSignUp;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)btnForBack:(id)sender;
- (IBAction)btnForSignUp:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnForCheckTOCObj;
@property (nonatomic,strong) IBOutlet NSString *isCheck;
- (IBAction)btnForCheckTOC:(id)sender;

@end
