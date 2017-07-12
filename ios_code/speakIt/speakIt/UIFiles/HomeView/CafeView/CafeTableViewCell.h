//
//  CafeTableViewCell.h
//  speakIt
//
//  Created by Mastek on 14/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CafeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgForPhoto;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblDetail;

@end
