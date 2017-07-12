//
//  WebService.m
//  Feedback
//
//  Created by Mastek on 22/05/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "WebService.h"

@implementation WebService

- (id)initWithTransaction:(NSString *)transactionType andUser:(User *)user
{
    if (self = [super init]){
        NSString *urlstring =[self getUrlFormat:transactionType ForUser:user];
        NSURL *url = [NSURL URLWithString:urlstring];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        /*
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          // ...
                                      }];
        [task resume];
         */
        [connection start];
    }
    return self;
}

-(NSString *)getUrlFormat:(NSString *)transactionType ForUser:(User *)user
{
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:WEBSERVICEURL];
    
    //Sign Up Service
    if([transactionType isEqualToString:SIGNUP]){
        NSString *msgString = [NSString stringWithFormat:@"email=%@&mobile=%@&username=%@&password=%@",user.userEmail,user.userMobile,user.userMobile,user.userPassword];
        [urlString appendString:[NSString stringWithFormat:@"loginUser/createUser?%@",msgString]];
        NSLog(@"Signup url-%@",urlString);
    }
    else{
        
    }
    
    return urlString;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!receivedData)
    {
        receivedData = [[NSMutableData alloc] initWithData:data];
    }
    else
    {
        [receivedData appendData:data];
    }
}

// all worked
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    [_webResponsedelegate getWebResponse:responseString];
}

// and error occured
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_webResponsedelegate getWebResponse:nil];
}

@end
