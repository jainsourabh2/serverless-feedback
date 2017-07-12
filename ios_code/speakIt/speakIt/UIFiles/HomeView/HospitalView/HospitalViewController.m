//
//  HospitalViewController.m
//  speakIt
//
//  Created by Mastek on 23/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "HospitalViewController.h"
#import "HospitalTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"


@interface HospitalViewController ()

@end

@implementation HospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    firstLatLong = YES;
    [self setUpView];
}

-(void)setUpView
{
    arrOfHospital = [[NSArray alloc]init];
    
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
        [self getHospitalData];
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

- (void)getHospitalData
{
    NSString *strType = @"hospital";
    
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
        arrOfHospital = [tempDict objectForKey:@"results"];
        
        //Write out the data to the console.
        NSLog(@"Google Data: %@", arrOfHospital);
        [_tableForHospital reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        [self showAlert:@"Don't have any data.."];
    }];
    
    
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count-%lu",(unsigned long)[arrOfHospital count]);
    return [arrOfHospital count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HospitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HospitalTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.lblName.text = [[arrOfHospital objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.lblDetail.text = [[arrOfHospital objectAtIndex:indexPath.row] objectForKey:@"vicinity"];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imgForPhoto sd_setImageWithURL:[NSURL URLWithString:[arrOfHospital[indexPath.row] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView == _tableForHospital)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        HospitalTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.delegatesHospital goForFeedbackPageHospital:[[arrOfHospital objectAtIndex:indexPath.row] objectForKey:@"name"] isAddress:[[arrOfHospital objectAtIndex:indexPath.row] objectForKey:@"vicinity"] urlIcon:[NSURL URLWithString:[arrOfHospital[indexPath.row] objectForKey:@"icon"]] isPlaceId:[[arrOfHospital objectAtIndex:indexPath.row] objectForKey:@"place_id"] isPhotoRef:[[[[arrOfHospital objectAtIndex:indexPath.row] objectForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0] isRating:[[arrOfHospital objectAtIndex:indexPath.row] objectForKey:@"rating"]];
        
        NSLog(@"Section:%ld Row:%ld selected and its data is %@",(long)indexPath.section,(long)indexPath.row,cell.lblName.text);
    }
    
}


@end
