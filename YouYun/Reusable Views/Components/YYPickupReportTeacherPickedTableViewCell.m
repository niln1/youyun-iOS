//
//  YYPickupReportTeacherPickedTableViewCell.m
//  YouYun
//
//  Created by Zhihao Ni on 11/10/14.
//  Copyright (c) 2014 Youyun. All rights reserved.
//

#import "YYPickupReportTeacherPickedTableViewCell.h"

@implementation YYPickupReportTeacherPickedTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setupUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI
{
    self.studentImageView.layer.cornerRadius = self.studentImageView.frame.size.height /2;
    self.studentImageView.layer.masksToBounds = YES;
    self.studentImageView.layer.borderWidth = 1;
    self.studentImageView.layer.borderColor = SCHOOL_COLOR.CGColor;
    
    self.pickedUpSwitch.onTintColor = SCHOOL_COLOR;
    self.contentView.backgroundColor = BG_COLOR;
    self.studentNameLabel.textColor = SCHOOL_COLOR;
    self.pickedUpTimeLabel.textColor = SCHOOL_VERY_LIGHT_COLOR;
}

@end
