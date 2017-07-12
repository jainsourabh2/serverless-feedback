//
//  CafeViewController.h
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol cafeDetailDelegate <NSObject>
-(void)goForFeedbackPageCafe:(NSString *)cafeName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr;
@end


@interface CafeViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    BOOL firstLaunch;
    BOOL firstLatLong;
    
    //Temp parameter
    NSString *currentLat;
    NSString *currentLong;
    
    NSArray *arrOfCafe;
}

@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableForCafe;

@property (nonatomic, assign) id <cafeDetailDelegate> delegatesCafe;
@end
