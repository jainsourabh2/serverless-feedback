//
//  OtpViewController.h
//  speakIt
//
//  Created by Mastek on 12/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtpViewController : UIViewController<UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtFirst;
@property (weak, nonatomic) IBOutlet UITextField *txtSecond;
@property (weak, nonatomic) IBOutlet UITextField *txtThird;
@property (weak, nonatomic) IBOutlet UITextField *txtFour;
@property (weak, nonatomic) IBOutlet UITextField *txtFive;
@property (weak, nonatomic) IBOutlet UITextField *txtSix;

- (IBAction)btnForBack:(id)sender;
- (IBAction)btnForSubmitOtp:(id)sender;
- (IBAction)btnForResendOTP:(id)sender;

@end
