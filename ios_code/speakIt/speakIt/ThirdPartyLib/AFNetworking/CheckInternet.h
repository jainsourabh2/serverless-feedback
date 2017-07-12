//
//  CheckInternet.h
//  health
//
//  Created by Krunal on 26/10/16.
//  Copyright © 2016 mastek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInternet : NSObject

+ (void)startNetworkMonitoring;
+ (BOOL)isInternetConnectionAvailable;
@end
