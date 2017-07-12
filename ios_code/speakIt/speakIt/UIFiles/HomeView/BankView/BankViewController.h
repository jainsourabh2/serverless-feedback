//
//  BankViewController.h
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol bankDetailDelegate <NSObject>
-(void)goForFeedbackPageBank:(NSString *)bankName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr;
@end

@interface BankViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    BOOL firstLaunch;
    BOOL firstLatLong;
    
    //Temp parameter
    NSString *currentLat;
    NSString *currentLong;
    
    NSArray *arrOfBank;
}

@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableForBank;

@property (nonatomic, assign) id <bankDetailDelegate> delegatesBank;

@end
