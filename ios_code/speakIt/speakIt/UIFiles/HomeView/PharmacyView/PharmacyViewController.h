//
//  PharmacyViewController.h
//  speakIt
//
//  Created by Mastek on 23/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol pharmacyDetailDelegate <NSObject>
-(void)goForFeedbackPagePharmacy:(NSString *)pharmacyName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr;
@end

@interface PharmacyViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    BOOL firstLaunch;
    BOOL firstLatLong;
    
    //Temp parameter
    NSString *currentLat;
    NSString *currentLong;
    
    NSArray *arrOfPharmacy;
}

@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableForPharmacy;

@property (nonatomic, assign) id <pharmacyDetailDelegate> delegatesPharmacy;

@end
