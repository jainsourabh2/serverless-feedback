//
//  CheckInternet.m
//  health
//
//  Created by Krunal on 26/10/16.
//  Copyright © 2016 mastek. All rights reserved.
//

#import "CheckInternet.h"
#import "AFNetworking.h"

@implementation CheckInternet


+ (void)startNetworkMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
        // Check the reachability status and show an alert if the internet connection is not available
        switch (status) {
            case -1:
              //  NSLog(@"The reachability status is Unknown");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"statusChanged" object:@"NO"];
                break;
            case 0:
                //   NSLog(@"The reachability status is not reachable");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"statusChanged" object:@"NO"];
                break;
            case 1:
               // NSLog(@"The reachability status is reachable via wan");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"statusChanged" object:@"YES"];
                break;
            case 2:
               // NSLog(@"The reachability status is reachable via WiFi");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"statusChanged" object:@"YES"];
                break;
                
            default:
                break;
        }
        
    }];
}

#pragma mark - Check Internet Network Status
+ (BOOL)isInternetConnectionAvailable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
