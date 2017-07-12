//
//  CouponViewController.m
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "CouponViewController.h"
#import "HomeViewController.h"
#import "UIImageView+WebCache.h"

@interface CouponViewController ()

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"strCouponName: %@ \n %@ \n %@ \n %@",_detailCouponName, _detailCouponDesc, _detailCouponCode, _detailCouponExpiry);
    
    _lblName.text = [[NSUserDefaults standardUserDefaults] valueForKey:PLACENAME];;
    _lblAddress.text = [[NSUserDefaults standardUserDefaults] valueForKey:PLACEADDRESS];;
    //_lblName.text = _detailCouponName;
    _txtviewDesc.text = _detailCouponDesc;
    _lblCode.text = [NSString stringWithFormat:@"Copoun Code : %@",_detailCouponCode];
    _lblexpiry.text = _detailCouponExpiry;
    
    NSLog(@"URL:%@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_RICON]);

    [_imgForRIcon sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_RICON]] placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
    
    [self generateQRCode];
}

#pragma mark - generate qr code
-(void)generateQRCode
{
    // Get the string
    NSString *stringToEncode = _detailCouponCode;
    
    // Generate the image
    CIImage *qrCode = [self createQRForString:stringToEncode];
    
    // Convert to an UIImage
    UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:2*[[UIScreen mainScreen] scale]];
    
    // And push the image on to the screen
    self.qrImageView.image = qrCodeImg;
}

- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                                scale:scaledImage.scale
                                          orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;
}

#pragma mark - Button for save coupon
- (IBAction)btnForSaveCoupon:(id)sender {
    /*Save as coupon view in my iphone photos*/
    //first we will make an UIImage from your view
    UIGraphicsBeginImageContext(ViewForCoupon.bounds.size);
    [ViewForCoupon.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //now we will position the image, X/Y away from top left corner to get the portion we want
    //    UIGraphicsBeginImageContext(self.view.frame.size);
    UIGraphicsBeginImageContext(ViewForCoupon.bounds.size);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(croppedImage,self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
            message:@"Image could not be saved.Please try again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button Ok");
            }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
            message:@"Image was successfully saved in photoalbum" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"You pressed button Ok");
                HomeViewController *homeView = GETVIEWCONTROLLERFROMIDENTIFIER(@"HomeViewController");
                [self presentViewController:homeView animated:NO completion:^{
                    
                }];
                /*
                //For go to home view
                NSMutableArray *arr = [[self.navigationController viewControllers] mutableCopy];
                HomeViewController *viewCOnntroller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                
                [arr insertObject:viewCOnntroller atIndex:0];
                self.navigationController.viewControllers = arr;
                
                NSLog(@"After: %@",self.navigationController.viewControllers);
                
                for(UIViewController *controller in [self.navigationController viewControllers])
                {
                    if([controller isKindOfClass:[HomeViewController class]])
                    {
                        [self.navigationController popToViewController:controller animated:NO];
                        
                    }
                }
                 */
            }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    //[self.navigationController popToRootViewControllerAnimated:YES];  //Go to home view controller
}

#pragma mark - back button
- (IBAction)btnForBack:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:NO];
    HomeViewController *homeView = GETVIEWCONTROLLERFROMIDENTIFIER(@"HomeViewController");
    [self presentViewController:homeView animated:NO completion:^{
        
    }];
    /*
    //For go to home view
    NSMutableArray *arr = [[self.navigationController viewControllers] mutableCopy];
    HomeViewController *viewCOnntroller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [arr insertObject:viewCOnntroller atIndex:0];
    self.navigationController.viewControllers = arr;
    
    NSLog(@"After: %@",self.navigationController.viewControllers);
    
    for(UIViewController *controller in [self.navigationController viewControllers])
    {
        if([controller isKindOfClass:[HomeViewController class]])
        {
            //[self.navigationController popToViewController:controller animated:NO];
        }
    }
     */
}



@end
