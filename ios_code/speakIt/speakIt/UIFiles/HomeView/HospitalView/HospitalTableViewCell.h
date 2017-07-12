//
//  HospitalTableViewCell.h
//  speakIt
//
//  Created by Mastek on 23/06/17.
//  Copyright © 2017 Mastek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgForPhoto;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblDetail;

@end
