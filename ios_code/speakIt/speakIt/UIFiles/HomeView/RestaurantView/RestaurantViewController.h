//
//  RestaurantViewController.h
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol restaurantDetailDelegate <NSObject>
-(void)goForFeedbackPage:(NSString *)restaurantName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr;
@end

@interface RestaurantViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,WebResponseProtocol>
{
    CLLocationManager *locationManager;
    BOOL firstLaunch;
    BOOL firstLatLong;
    
    //Temp parameter
    NSString *currentLat;
    NSString *currentLong;
    
    NSArray *arrOfRestaurant;
}

@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableForRestaurant;

@property (nonatomic, assign) id <restaurantDetailDelegate> delegatesRest;

@end
