//
//  SchoolViewController.h
//  speakIt
//
//  Created by Mastek on 23/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol schoolDetailDelegate <NSObject>
-(void)goForFeedbackPageSchool:(NSString *)schoolName isAddress:(NSString *)address urlIcon:(NSURL *)isIconUrl isPlaceId:(NSString *)placeId isPhotoRef:(NSString *)photoRef isRating:(NSString *)ratingStr;
@end


@interface SchoolViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    BOOL firstLaunch;
    BOOL firstLatLong;
    
    //Temp parameter
    NSString *currentLat;
    NSString *currentLong;
    
    NSArray *arrOfSchool;
}

@property(nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITableView *tableForSchool;

@property (nonatomic, assign) id <schoolDetailDelegate> delegatesSchool;

@end
