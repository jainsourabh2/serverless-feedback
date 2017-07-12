//
//  RoundedBorderView.m
//  speakIt
//
//  Created by Mastek on 05/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "RoundedBorderView.h"

@implementation RoundedBorderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.layer.borderColor = [[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1] CGColor];
    //self.layer.borderColor = aetnaGrey.CGColor;
    
}

@end
