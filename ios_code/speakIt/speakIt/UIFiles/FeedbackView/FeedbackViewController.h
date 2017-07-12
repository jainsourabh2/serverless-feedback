//
//  FeedbackViewController.h
//  speakIt
//
//  Created by Mastek on 08/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//
//http://www.theappguruz.com/blog/uipageviewcontroller-in-ios

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UIPageViewControllerDelegate>  //UIPageViewControllerDataSource ---Commented datasource because hide geuster horizontal scroll
{
    //NSArray *arrForQue;
    NSMutableDictionary *dictData;
}

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgForbgRestaurant;
@property (weak, nonatomic) IBOutlet UIImageView *imgForRestaurantIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgForRestaurantRating;
//For display feedback values
@property (strong, nonatomic) IBOutlet NSString *strName;
@property (strong, nonatomic) IBOutlet NSString *strAddress;
@property (strong, nonatomic) IBOutlet NSURL *strURlIcon;
@property (strong, nonatomic) IBOutlet NSString *strPlaceId;
@property (strong, nonatomic) IBOutlet NSString *strPhotoRef;
@property (strong, nonatomic) IBOutlet NSString *strRating;
- (IBAction)btnForBack:(id)sender;



//For Page view - multiple
@property (strong, nonatomic) UIPageViewController *pageController;

@end
