//
//  CouponViewController.h
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponViewController : UIViewController
{
    IBOutlet UIView *ViewForCoupon;
}
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imgForRIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UITextView *txtviewDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UILabel *lblexpiry;
@property (strong, nonatomic) IBOutlet NSString *detailCouponName;
@property (strong, nonatomic) IBOutlet NSString *detailCouponDesc;
@property (strong, nonatomic) IBOutlet NSString *detailCouponCode;
@property (strong, nonatomic) IBOutlet NSString *detailCouponExpiry;

- (IBAction)btnForSaveCoupon:(id)sender;
- (IBAction)btnForBack:(id)sender;
@end
