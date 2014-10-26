//
//  YYPickupReportTeacherTableViewCell.m
//  YouYun
//
//  Created by Zhihao Ni on 8/12/14.
//  Copyright (c) 2014 Ranchao Zhang. All rights reserved.
//

#import "YYPickupReportTeacherTableViewCell.h"

@implementation YYPickupReportTeacherTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.studentImageView.layer.cornerRadius = self.studentImageView.frame.size.height /2;
        self.studentImageView.layer.masksToBounds = YES;
        self.studentImageView.layer.borderWidth = 0;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.studentImageView.layer.cornerRadius = self.studentImageView.frame.size.height /2;
    self.studentImageView.layer.masksToBounds = YES;
    self.studentImageView.layer.borderWidth = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
