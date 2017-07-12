//
//  BaseViewController.h
//  speakIt
//
//  Created by Mastek on 07/07/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic, readonly, retain) UINavigationController *navigationController;
+(void) getLoginAfterAuthExpire:(NSString *)un ispass:(NSString *)pass;

@end
