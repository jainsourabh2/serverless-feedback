//
//  RoundedButtonView.m
//  speakIt
//
//  Created by Mastek on 05/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import "RoundedButtonView.h"

@implementation RoundedButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    [super awakeFromNib];
    //self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.cornerRadius = 8;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    //self.layer.borderColor = [UIColor blueColor].CGColor;
    
}

@end
