//
//  FeedbackViewController.m
//  speakIt
//
//  Created by Mastek on 08/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "PageContentViewController.h"

#import "CouponViewController.h"
#import "ThankYouViewController.h"

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "NSData+Base64.h"
#import "HomeViewController.h"


@interface FeedbackViewController ()<nextpagerDelegate>
@property (nonatomic, strong) NSArray *viewControllers;
@end

@implementation FeedbackViewController

-(void)viewWillAppear:(BOOL)animated
{
//    arrForQue = [[NSArray alloc]init];
//    dictData = [[NSMutableDictionary alloc]init];
//    [self fetchQuestionList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewControllers = [[NSArray alloc]init];
    dictData = [[NSMutableDictionary alloc]init];
    [self fetchQuestionList];
    
    NSLog(@"NAME - %@ * %@",_strAddress,_strName);
    NSLog(@"url - %@",_strURlIcon);
    
    _lblName.text = _strName;
    _lblAddress.text = _strAddress;
    
    //store name & address on nsuserdefault data
    [[NSUserDefaults standardUserDefaults] setObject:_strName forKey:PLACENAME];
    [[NSUserDefaults standardUserDefaults] setObject:_strAddress forKey:PLACEADDRESS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_imgForRestaurantIcon sd_setImageWithURL:[NSURL URLWithString:[_strURlIcon absoluteString]] placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
    NSLog(@"Place id: %@",_strPlaceId);
    NSLog(@"Rating: %@",_strRating);
    float rateStar = [_strRating floatValue];
    
    //float theFloat = 1.23456;
    int rounded = roundf(rateStar); NSLog(@"%d",rounded);
    int roundedUp = ceil(rateStar); NSLog(@"%d",roundedUp);
    int roundedDown = floor(rateStar); NSLog(@"%d",roundedDown);
    // Note: int can be replaced by float
    
    if (roundedUp == 1) {
        _imgForRestaurantRating.image = [UIImage imageNamed:@"1stars.png"];
    }else if (roundedUp == 2){
        _imgForRestaurantRating.image = [UIImage imageNamed:@"2stars.png"];
    }else if (roundedUp == 3){
        _imgForRestaurantRating.image = [UIImage imageNamed:@"3stars.png"];
    }else if (roundedUp == 4){
        _imgForRestaurantRating.image = [UIImage imageNamed:@"4star.png"];
    }else if (roundedUp == 5){
        _imgForRestaurantRating.image = [UIImage imageNamed:@"5star.png"];
    }else{
        _imgForRestaurantRating.image = [UIImage imageNamed:@"Noimage.png"];
    }
    
    //_viewControllers = [[NSArray alloc]initWithObjects:@"1 how is the ??",@"2 how is the ??",@"3 how is the ??",@"4 how is the ??",@"5 how is the ??", nil];
    //NSLog(@"Array size: %@",_viewControllers);
    
    /*
     //For view did load code
    // Create page view controller
    self.pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageController.dataSource = self;  //---Commented datasource because hide geuster horizontal scroll
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    [self.pageController didMoveToParentViewController:self];
     */
    
}



#pragma mark - Fetch question list
-(void)fetchQuestionList
{
    User *user = [[User alloc] init];
    user.userPlaceId = _strPlaceId;
    user.userAuthorization = [[NSUserDefaults standardUserDefaults] valueForKey:USER_AUTHORIZATION];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    //For using dictionary with array parameter
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            user.userPlaceId, @"placeid",
                            nil];
    NSLog(@"params-->%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //..Start Custom add "Authorization" header
    [manager.requestSerializer setValue:user.userAuthorization forHTTPHeaderField:@"Authorization"];
    //..End
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSLog(@"Url:%@",[NSString stringWithFormat:@"%@questions/fetchquestions",WEBSERVICEURL]);
    
    [manager GET:[NSString stringWithFormat:@"%@questions/fetchquestions",WEBSERVICEURL] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON--------- %@", responseObject);
        [SVProgressHUD dismiss];
        [self.view setUserInteractionEnabled:YES];
        
        NSDictionary *tempDict = (NSDictionary*)responseObject;
        
        if ([[tempDict objectForKey:@"message"] isEqualToString:@"Place not configured"]) {
            [self showAlert:@"Place not configured..!"];
            [self getPlacePicture];
        }else{
            _viewControllers = [tempDict objectForKey:@"results"];
            //Write out the data to the console.
            NSLog(@"Question Data: %@", _viewControllers);
            
            //..Start for set default rating 3 Star
            for (int i=1; i<=[_viewControllers count]; i++) {
                [dictData setObject:@"3" forKey:[_viewControllers objectAtIndex:i-1]];
            }
            NSLog(@"dict: %@",dictData);
            //..End for set default rating 3 Star
            
            //..page view controller start
            // Create page view controller
            self.pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
            //self.pageController.dataSource = self;  //---Commented datasource because hide geuster horizontal scroll
            
            PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
            startingViewController.delegatesNext = self;   //For using next delegate.
            NSArray *viewControllers = @[startingViewController];
            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            // Change the size of page view controller  //60
            self.pageController.view.frame = CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height);
            
            [self addChildViewController:_pageController];
            [self.view addSubview:_pageController.view];
            [self.pageController didMoveToParentViewController:self];
            //..page view controller end
            
            //..Get background picture
            [self getPlacePicture];
        
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlert:@"Don't have any data.."];
    }];
}

-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            NSLog(@"You pressed button Ok");
                        }];
    
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)btnForBack:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    //For go to specific view
    
    HomeViewController *homeView = GETVIEWCONTROLLERFROMIDENTIFIER(@"HomeViewController");
    [self presentViewController:homeView animated:NO completion:^{
        
    }];

}

#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).indexPage;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).indexPage;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.viewControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.viewControllers count] == 0) || (index >= [self.viewControllers count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    //Pass the values for page content view controller
    pageContentViewController.screenNumber = self.viewControllers[index];
    pageContentViewController.indexPage = index;
    pageContentViewController.totalSize = [self.viewControllers count];
    pageContentViewController.strQuestion = self.viewControllers[index];
    pageContentViewController.dictForQueWithFeed = dictData;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [_viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

#pragma mark- Go for next pager
//delegate call
-(void)goForNextViewPager:(NSString *)pageName
{
    [self changePage:UIPageViewControllerNavigationDirectionForward];
}

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    NSUInteger pageIndex = ((PageContentViewController *) [_pageController.viewControllers objectAtIndex:0]).indexPage;
    if (direction == UIPageViewControllerNavigationDirectionForward){
        pageIndex++;
    }else {
        pageIndex--;
    }
    PageContentViewController *viewController = [self viewControllerAtIndex:pageIndex];
    viewController.delegatesNext = self;   //For using next delegate.
    
    if (viewController == nil) {
        return;
    }
    [_pageController setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
}

#pragma mark - getPlacePicture
-(void)getPlacePicture{
    User *user = [[User alloc] init];
    user.userPhotoReference = _strPhotoRef;
    user.userAuthorization = [[NSUserDefaults standardUserDefaults] valueForKey:USER_AUTHORIZATION];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    //For using dictionary with array parameter
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            user.userPhotoReference, @"photoReference",
                            nil];
    NSLog(@"params-->%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //..Start Custom add "Authorization" header
    [manager.requestSerializer setValue:user.userAuthorization forHTTPHeaderField:@"Authorization"];
    //..End
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSLog(@"Url:%@",[NSString stringWithFormat:@"%@places/placeDetails",WEBSERVICEURL]);
    
    [manager GET:[NSString stringWithFormat:@"%@places/placeDetails",WEBSERVICEURL] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON--------- %@", responseObject);
        [SVProgressHUD dismiss];
        [self.view setUserInteractionEnabled:YES];
        
        NSDictionary *tempDict = (NSDictionary*)responseObject;
        NSLog(@"tempDict:%@",tempDict);
        if ([[[tempDict objectForKey:@"statusCode"] stringValue] isEqualToString:@"200"]) {
            NSData *data = [[NSData alloc] initWithData:[NSData
                                                         dataFromBase64String:[tempDict objectForKey:@"out"]]];
            //Now data is decoded. You can convert them to UIImage
            UIImage *imagepro = [UIImage imageWithData:data];
            [_imgForbgRestaurant setImage:imagepro];
        }else if([[tempDict objectForKey:@"message"] isEqualToString:@"Unauthorized"]){
            [self showAlert:@"Please check your authorization data.."];
        }
       
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlert:@"Don't have any data.."];
    }];
    
}

@end
