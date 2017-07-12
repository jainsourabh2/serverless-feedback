//
//  PageContentViewController.h
//  speakIt
//
//  Created by Mastek on 15/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSTapRateView.h"

@protocol nextpagerDelegate <NSObject>
-(void) goForNextViewPager:(NSString *)pageName;
@end

@interface PageContentViewController : UIViewController<RSTapRateViewDelegate>
{
    NSMutableDictionary *dictForQueWithFeed;
}

@property (nonatomic, retain) RSTapRateView *tapRateView;   //Rate view star

@property (assign, nonatomic) NSInteger indexPage;
@property (assign, nonatomic) NSInteger totalSize;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblQuestion;
@property NSString *strQuestion;
@property NSMutableDictionary *dictForQueWithFeed;
@property (weak, nonatomic) IBOutlet UIButton *btnForFinishObj;
@property (weak, nonatomic) IBOutlet UIButton *btnForNextObj;

- (IBAction)btnForNext:(id)sender;
- (IBAction)btnForFinish:(id)sender;

@property (nonatomic, assign) id <nextpagerDelegate> delegatesNext;

@end
