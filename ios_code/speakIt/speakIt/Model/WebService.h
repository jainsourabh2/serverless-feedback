//
//  WebService.h
//  Feedback
//
//  Created by Mastek on 22/05/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Constant.h"

@interface WebService : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *receivedData;
    NSURLConnection *connection;
}

@property (nonatomic,weak) id<WebResponseProtocol> webResponsedelegate;
- (id)initWithTransaction:(NSString *)transactionType andUser:(User *)user;

@end
