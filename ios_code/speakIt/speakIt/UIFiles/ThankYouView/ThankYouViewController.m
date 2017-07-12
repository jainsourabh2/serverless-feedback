//
//  ThankYouViewController.m
//  speakIt
//
//  Created by Mastek on 07/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "ThankYouViewController.h"
#import "HomeViewController.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnForBack:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:NO];
    HomeViewController *homeView = GETVIEWCONTROLLERFROMIDENTIFIER(@"HomeViewController");
    [self presentViewController:homeView animated:NO completion:^{
        
    }];
    /*
    //For go to home view
    NSMutableArray *arr = [[self.navigationController viewControllers] mutableCopy];
    HomeViewController *viewCOnntroller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [arr insertObject:viewCOnntroller atIndex:0];
    self.navigationController.viewControllers = arr;
    
    NSLog(@"After: %@",self.navigationController.viewControllers);
    
    for(UIViewController *controller in [self.navigationController viewControllers])
    {
        if([controller isKindOfClass:[HomeViewController class]])
        {
            [self.navigationController popToViewController:controller animated:NO];
            
        }
    }
    */
}

- (IBAction)btnForExit:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:NO];
    HomeViewController *homeView = GETVIEWCONTROLLERFROMIDENTIFIER(@"HomeViewController");
    [self presentViewController:homeView animated:NO completion:^{
        
    }];
    /*
    //For go to home view
    NSMutableArray *arr = [[self.navigationController viewControllers] mutableCopy];
    HomeViewController *viewCOnntroller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [arr insertObject:viewCOnntroller atIndex:0];
    self.navigationController.viewControllers = arr;
    
    NSLog(@"After: %@",self.navigationController.viewControllers);
    
    for(UIViewController *controller in [self.navigationController viewControllers])
    {
        if([controller isKindOfClass:[HomeViewController class]])
        {
            //[self.navigationController popToViewController:controller animated:NO];
            [self presentViewController:controller animated:NO completion:^{
                
            }];
        }
    }
     */
}

@end
