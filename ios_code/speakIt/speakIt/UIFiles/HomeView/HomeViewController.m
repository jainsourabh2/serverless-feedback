//
//  HomeViewController.m
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "HomeViewController.h"
#import "CAPSPageMenu.h"   //For tabs menu

#import "RestaurantViewController.h"
#import "CafeViewController.h"
#import "BankViewController.h"
#import "PharmacyViewController.h"
#import "HospitalViewController.h"
#import "SchoolViewController.h"

#import "FeedbackViewController.h"

@interface HomeViewController ()<CAPSPageMenuDelegate,restaurantDetailDelegate,cafeDetailDelegate,bankDetailDelegate,pharmacyDetailDelegate,schoolDetailDelegate,hospitalDetailDelegate>
@property (nonatomic) CAPSPageMenu *pageMenu;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RestaurantViewController *restaurantTab = GETVIEWCONTROLLERFROMIDENTIFIER(@"RestaurantViewController");
    restaurantTab.title = @"Restaurant";
    restaurantTab.delegatesRest = self;
    CafeViewController *cafeTab = GETVIEWCONTROLLERFROMIDENTIFIER(@"CafeViewController");
    cafeTab.title = @"Cafe";
    cafeTab.delegatesCafe = self;
    BankViewController *bankTab = GETVIEWCONTROLLERFROMIDENTIFIER(@"BankViewController");
    bankTab.title = @"Bank";
    bankTab.delegatesBank = self;
    PharmacyViewController *pharmacyTab = GETVIEWCONTROLLERFROMIDENTIFIER(@"PharmacyViewController");
    pharmacyTab.title = @"Pharmacy";
    pharmacyTab.delegatesPharmacy = self;
    SchoolViewController *schoolTab = GETVIEWCONTROLLERFROMIDENTIFIER(@"SchoolViewController");
    schoolTab.title = @"School";
    schoolTab.delegatesSchool = self;
    HospitalViewController *hospitalTab = GETVIEWCONTROLLERFROMIDENTIFIER(@"HospitalViewController");
    hospitalTab.title = @"Hospital";
    hospitalTab.delegatesHospital = self;
    
    
    NSArray *controllerArray = @[restaurantTab, cafeTab, bankTab, pharmacyTab, schoolTab, hospitalTab];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:43.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:255.0/255.0 green:80.0/255.0 blue:84.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:15.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 70.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
}
//For restaurant delegate
-(void) goForFeedbackPage:(NSString *)restaurantName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr
{
    FeedbackViewController *feedView = GETVIEWCONTROLLERFROMIDENTIFIER(@"FeedbackViewController");
    feedView.strName = restaurantName;
    feedView.strAddress = address;
    feedView.strURlIcon = isIconUrl;
    feedView.strPlaceId = placeId;
    feedView.strPhotoRef = photoRef;
    feedView.strRating = ratingStr;
    NSString *iURL = [isIconUrl absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:placeId forKey:USER_PLACEID];
    [[NSUserDefaults standardUserDefaults] setObject:iURL forKey:USER_RICON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.navigationController pushViewController:feedView animated:NO];
    [self presentViewController:feedView animated:NO completion:nil];
}

//For cafe delegate
-(void)goForFeedbackPageCafe:(NSString *)cafeName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr
{
    FeedbackViewController *feedView = GETVIEWCONTROLLERFROMIDENTIFIER(@"FeedbackViewController");
    feedView.strName = cafeName;
    feedView.strAddress = address;
    feedView.strURlIcon = isIconUrl;
    feedView.strPlaceId = placeId;
    feedView.strPhotoRef = photoRef;
    feedView.strRating = ratingStr;
    NSString *iURL = [isIconUrl absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:placeId forKey:USER_PLACEID];
    [[NSUserDefaults standardUserDefaults] setObject:iURL forKey:USER_RICON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.navigationController pushViewController:feedView animated:NO];
    [self presentViewController:feedView animated:NO completion:nil];
}

//For bank delegete
-(void)goForFeedbackPageBank:(NSString *)bankName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr
{
    FeedbackViewController *feedView = GETVIEWCONTROLLERFROMIDENTIFIER(@"FeedbackViewController");
    feedView.strName = bankName;
    feedView.strAddress = address;
    feedView.strURlIcon = isIconUrl;
    feedView.strPlaceId = placeId;
    feedView.strPhotoRef = photoRef;
    feedView.strRating = ratingStr;
    NSString *iURL = [isIconUrl absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:placeId forKey:USER_PLACEID];
    [[NSUserDefaults standardUserDefaults] setObject:iURL forKey:USER_RICON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.navigationController pushViewController:feedView animated:NO];
    [self presentViewController:feedView animated:NO completion:nil];
}

//For pharmacy delegate
-(void)goForFeedbackPagePharmacy:(NSString *)pharmacyName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr
{
    FeedbackViewController *feedView = GETVIEWCONTROLLERFROMIDENTIFIER(@"FeedbackViewController");
    feedView.strName = pharmacyName;
    feedView.strAddress = address;
    feedView.strURlIcon = isIconUrl;
    feedView.strPlaceId = placeId;
    feedView.strPhotoRef = photoRef;
    feedView.strRating = ratingStr;
    NSString *iURL = [isIconUrl absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:placeId forKey:USER_PLACEID];
    [[NSUserDefaults standardUserDefaults] setObject:iURL forKey:USER_RICON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.navigationController pushViewController:feedView animated:NO];
    [self presentViewController:feedView animated:NO completion:nil];
}

//For school delegate
-(void)goForFeedbackPageSchool:(NSString *)schoolName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr
{
    FeedbackViewController *feedView = GETVIEWCONTROLLERFROMIDENTIFIER(@"FeedbackViewController");
    feedView.strName = schoolName;
    feedView.strAddress = address;
    feedView.strURlIcon = isIconUrl;
    feedView.strPlaceId = placeId;
    feedView.strPhotoRef = photoRef;
    feedView.strRating = ratingStr;
    NSString *iURL = [isIconUrl absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:placeId forKey:USER_PLACEID];
    [[NSUserDefaults standardUserDefaults] setObject:iURL forKey:USER_RICON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.navigationController pushViewController:feedView animated:NO];
    [self presentViewController:feedView animated:NO completion:nil];
}

//For hospital deleaget
-(void)goForFeedbackPageHospital:(NSString *)hospitalName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr
{
    FeedbackViewController *feedView = GETVIEWCONTROLLERFROMIDENTIFIER(@"FeedbackViewController");
    feedView.strName = hospitalName;
    feedView.strAddress = address;
    feedView.strURlIcon = isIconUrl;
    feedView.strPlaceId = placeId;
    feedView.strPhotoRef = photoRef;
    feedView.strRating = ratingStr;
    NSString *iURL = [isIconUrl absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:placeId forKey:USER_PLACEID];
    [[NSUserDefaults standardUserDefaults] setObject:iURL forKey:USER_RICON];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.navigationController pushViewController:feedView animated:NO];
    [self presentViewController:feedView animated:NO completion:nil];

}

@end
