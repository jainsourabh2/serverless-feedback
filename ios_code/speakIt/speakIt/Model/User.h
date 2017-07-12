//
//  User.h
//  Feedback
//
//  Created by Mastek on 22/05/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//SignUp page
@property (nonatomic,strong) NSString *userEmail;
@property (nonatomic,strong) NSString *userMobile;
@property (nonatomic,strong) NSString *userPassword;

//Otp page
@property (nonatomic,strong) NSString *userPinOne;
@property (nonatomic,strong) NSString *userPinTwo;
@property (nonatomic,strong) NSString *userPinThree;
@property (nonatomic,strong) NSString *userPinFour;
@property (nonatomic,strong) NSString *userPinFive;
@property (nonatomic,strong) NSString *userPinSix;

//Login Page
@property (nonatomic,strong) NSString *userUsername;
@property (nonatomic,strong) NSString *userPass;

//Restaurant page
@property (nonatomic,strong) NSString *userLatitude;
@property (nonatomic,strong) NSString *userLongitude;
@property (nonatomic,strong) NSString *userDataType;
@property (nonatomic,strong) NSString *userPlaceId;
@property (nonatomic,strong) NSString *userAuthorization;
@property (nonatomic,strong) NSString *userPhotoReference;

@end
