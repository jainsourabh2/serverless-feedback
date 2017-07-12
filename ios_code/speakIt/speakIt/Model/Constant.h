//
//  Constant.h
//  Feedback
//
//  Created by Mastek on 22/05/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define GETVIEWCONTROLLERFROMIDENTIFIER(storyBoardIdentifier) [self.storyboard instantiateViewControllerWithIdentifier:storyBoardIdentifier];

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : 0)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : 0)

/* UAT Testing URL */
#define WEBSERVICEURL @"https://h20yfhi445.execute-api.us-west-2.amazonaws.com/dev/"


/* Production URL */
//#define WEBSERVICEURL @""

/* Common URL */
#define HELPURL @""

/* Define string to identify which function call*/
#define SIGNUP @"SIGNUP"
#define USER_MOBILENO @"USER_MOBILENO"
#define USER_PASSWORD @"USER_PASSWORD"
#define USER_AUTHORIZATION @"USER_AUTHORIZATION"
#define USER_PLACEID @"USER_PLACEID"
#define USER_RICON @"USER_RICON"
#define CHECKTERM @"checkterm"   // Using for terms & condition

#define PLACENAME @"PLACENAME"
#define PLACEADDRESS @"PLACEADDRESS"
/*
#define RESTAURANTLIST @"RESTAURANTLIST"
#define CAFELIST @"CAFELIST"
#define BANKLIST @"BANKLIST"
#define QUELIST @"QUELIST"
*/

@protocol WebResponseProtocol <NSObject>
-(void)getWebResponse:(NSString *)webresponse;
@end

@interface Constant : NSObject

//All define class methode
+(NSString *)getTrimmedString:(NSString *)inputString;
+(BOOL) isValidEmailID:(NSString *)_anID;

@end
