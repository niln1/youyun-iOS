//
//  YYPickupReportTeacherTableViewCell.h
//  YouYun
//
//  Created by Zhihao Ni on 8/12/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYPickupReportTeacherNeedPickTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *studentNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickedUpTimeLabel;
@property (nonatomic, weak) IBOutlet UISwitch *pickedUpSwitch;
@property (nonatomic, weak) IBOutlet UIImageView *studentImageView;

@end
