//
//  RestaurantViewController.m
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantTableViewCell.h"
#import "FeedbackViewController.h"

#import "ForgotPasswordViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    firstLatLong = YES;
    [self setUpView];
    
}

-(void)setUpView
{
    arrOfRestaurant = [[NSArray alloc]init];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc]init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Use either one of these authorizations **The top one gets called first and the other gets ignored
        [locationManager requestWhenInUseAuthorization];
        //[self.locationManager requestAlwaysAuthorization];
        
        [locationManager startUpdatingLocation];
    }
    else
    {
        /* Location services are not enabled*/
        NSLog(@"Location service are not enabled");
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(checkStatus)
                                                userInfo:nil repeats:NO];
    
    //Set the first launch instance variable to allow the map to zoom on the user location when first launched.
    firstLaunch=YES;
}

-(void)checkStatus
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status==kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Not Determined");
    }
    if (status==kCLAuthorizationStatusDenied) {
        NSLog(@"Denied");
    }
    if (status==kCLAuthorizationStatusRestricted) {
        NSLog(@"Restricted");
    }
    if (status==kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Always Allowed");
    }
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"When In Use Allowed");
    }
}

#pragma mark- CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        //On device
        //        currentLat = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];
        //        currentLong = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
        
        //custom
        currentLat = @"19.112189";
        currentLong = @"73.016490";
        
    }
    
    if (firstLatLong) {
        NSLog(@"current lat -->%@",currentLat);
        NSLog(@"current long -->%@",currentLong);
        [self getRestaurantData];
        firstLatLong = NO;
    }else{
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to receive user's location");
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"App Permission Denied"
                                                                       message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"You pressed button Ok");
                                                              }];
        
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)getRestaurantData
{
    NSString *strType = @"restaurant";
    
    User *user = [[User alloc] init];
    user.userLatitude = currentLat;
    user.userLongitude = currentLong;
    user.userDataType = strType;
    user.userAuthorization = [[NSUserDefaults standardUserDefaults] valueForKey:USER_AUTHORIZATION];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    //For using dictionary with array parameter
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            user.userLatitude, @"lat",
                            user.userLongitude, @"lng",
                            user.userDataType, @"type", 
                            nil];
    NSLog(@"params-->%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //..Start Custom add "Authorization" header
    [manager.requestSerializer setValue:user.userAuthorization forHTTPHeaderField:@"Authorization"];
    //..End
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSLog(@"Url:%@",[NSString stringWithFormat:@"%@places/locationlisting",WEBSERVICEURL]);
    
    [manager GET:[NSString stringWithFormat:@"%@places/locationlisting",WEBSERVICEURL] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON--------- %@", responseObject);
        [SVProgressHUD dismiss];
        [self.view setUserInteractionEnabled:YES];
        
        NSDictionary *tempDict = (NSDictionary*)responseObject;
        arrOfRestaurant = [tempDict objectForKey:@"results"];
        
        //Write out the data to the console.
        NSLog(@"Google Data: %@", arrOfRestaurant);
        [_tableForRestaurant reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlert:@"Don't have any data.."];
    }];
   
    /*
    NSString *strType = @"restaurant";
    
    User *user = [[User alloc] init];
    user.userLatitude = currentLat;
    user.userLongitude = currentLong;
    user.userDataType = strType;
    user.userAuthorization = [[NSUserDefaults standardUserDefaults] valueForKey:USER_AUTHORIZATION];
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    [self.view setUserInteractionEnabled:NO];
    WebService *webService = [[WebService alloc] initWithTransaction:RESTAURANTLIST andUser:user];
    webService.webResponsedelegate =self;
     */
    
}

-(void)showAlert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button Ok");
                                                          }];
    
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];

}

/* 
// For only get request data (Own Delegates)
-(void)getWebResponse:(NSString *)webresponse
{
    [SVProgressHUD dismiss];
    [self.view setUserInteractionEnabled:YES];
    if(webresponse == nil){
        [self showAlert:@"Please check your inernet connection..!"];
        return;
    }
    NSError *err = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[webresponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    if(!err){
        //The results from Google will be an array obtained from the NSDictionary object with the key "results".
        arrOfRestaurant = [dictionary objectForKey:@"results"];
        
        //Write out the data to the console.
        NSLog(@"Google Data: %@", arrOfRestaurant);
        [_tableForRestaurant reloadData];
    }else{
        [self showAlert:@"Don't have any data.."];
    }
}
*/

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count-%lu",(unsigned long)[arrOfRestaurant count]);
    return [arrOfRestaurant count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.lblName.text = [[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.lblDetail.text = [[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imgForPhoto sd_setImageWithURL:[NSURL URLWithString:[arrOfRestaurant[indexPath.row] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
    
    NSLog(@"photo ref:%@",[[[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0]);
    
    NSLog(@"rating-%@",[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"rating"]);
    NSLog(@"name:%@",[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"name"]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == _tableForRestaurant)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        RestaurantTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //Call delegate method
        [self.delegatesRest goForFeedbackPage:[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"name"] isAddress:[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"vicinity"] urlIcon:[NSURL URLWithString:[arrOfRestaurant[indexPath.row] objectForKey:@"icon"]] isPlaceId:[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"place_id"] isPhotoRef:[[[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0] isRating:[[arrOfRestaurant objectAtIndex:indexPath.row] objectForKey:@"rating"]];
        
        NSLog(@"Section:%ld Row:%ld selected and its data is %@",(long)indexPath.section,(long)indexPath.row,cell.lblName.text);
    }

}

@end
