//
//  HospitalViewController.h
//  speakIt
//
//  Created by Mastek on 23/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol hospitalDetailDelegate <NSObject>
-(void)goForFeedbackPageHospital:(NSString *)hospitalName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr;
@end

@interface HospitalViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    BOOL firstLaunch;
    BOOL firstLatLong;
    
    //Temp parameter
    NSString *currentLat;
    NSString *currentLong;
    
    NSArray *arrOfHospital;
}

@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableForHospital;

@property (nonatomic, assign) id <hospitalDetailDelegate> delegatesHospital;

@end
